// Stufe A der Lehrer-Daten: DB-Export (TSV) + Client-Dateien -> Tools/data/trainer_source.lua
//
//   node Tools/trainers/extract.mjs --wow "<WoW-Ordner>" --q1 trainers.tsv --q2 spawns.tsv \
//        [--out Tools/data/trainer_source.lua]
//
// trainers.tsv / spawns.tsv sind die Ausgaben von q_trainers.sql / q_spawns.sql (mysql -N -B).
// Dieses Skript liefert nur Rohwerte (keine Rang-, Fraktions- oder Zonenlogik); die Logik steckt
// in Tools/trainer_gen_lib.lua (Lua 5.1, von der Testsuite geprueft).
//
// Quellen im Client:
//   Data/deDE/*.MPQ  WorldMapArea.dbc, DungeonMap.dbc, FactionTemplate.dbc, AreaTable.dbc (deutsche Namen)
//   Data/enGB/*.MPQ  AreaTable.dbc (englische Namen)
//   Data/*.MPQ       ADT-Kacheln (MCNK-AreaID unter dem Spawn); private Buchstaben-Patches (patch-X.MPQ)
//                    werden bewusst ignoriert, damit die Daten dem Original-Client entsprechen.
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { openChain, readFromChain, parseDbc, f32, i32 } from './mpq.mjs';

const args = {};
for (let i = 2; i < process.argv.length; i += 2) args[process.argv[i].replace(/^--/, '')] = process.argv[i + 1];
const here = path.dirname(fileURLToPath(import.meta.url));
const OUT = args.out || path.join(here, '..', 'data', 'trainer_source.lua');
if (!args.wow || !args.q1 || !args.q2) {
  console.error('usage: node extract.mjs --wow <WoW-Ordner> --q1 trainers.tsv --q2 spawns.tsv [--out file]');
  process.exit(2);
}
const DATA = path.join(args.wow, 'Data');

const localeChain = (loc) => openChain([
  `locale-${loc}.MPQ`, `expansion-locale-${loc}.MPQ`, `lichking-locale-${loc}.MPQ`,
  `patch-${loc}.MPQ`, `patch-${loc}-2.MPQ`, `patch-${loc}-3.MPQ`,
].map((f) => path.join(DATA, loc, f)));
const de = localeChain('deDE');
const en = localeChain('enGB');
const dbc = (chain, name) => {
  const b = readFromChain(chain, 'DBFilesClient\\' + name);
  if (!b) throw new Error(name + ' nicht gefunden');
  return parseDbc(b);
};

const tsv = (f) => fs.readFileSync(f, 'utf8').split(/\r?\n/).filter(Boolean).map((l) => l.split('\t'));
const nul = (s) => (s === undefined || s === 'NULL' ? '' : s);

// --- Datenbank ---------------------------------------------------------------------------------
const trainers = tsv(args.q1).map(([entry, name, sub, nameDe, subDe, faction, skillLine, rankSpells]) => ({
  entry: +entry, name: nul(name), sub: nul(sub), nameDe: nul(nameDe), subDe: nul(subDe),
  faction: +faction, skillLine: +skillLine,
  rankSpells: nul(rankSpells)
    ? rankSpells.split(',').map((p) => p.split(':').map(Number)).sort((a, b) => a[0] - b[0])
    : [],
  spawns: [],
}));
const byEntry = new Map(trainers.map((t) => [t.entry, t]));
const spawnRows = tsv(args.q2);

// --- ADT-AreaID je Spawn -----------------------------------------------------------------------
const adtChain = openChain(['common.MPQ', 'common-2.MPQ', 'expansion.MPQ', 'lichking.MPQ',
  'patch.MPQ', 'patch-2.MPQ', 'patch-3.MPQ'].map((f) => path.join(DATA, f)));
const MAPDIR = { 0: 'Azeroth', 1: 'Kalimdor', 530: 'Expansion01', 571: 'Northrend' };
const TILE = 1600 / 3;
const adtCache = new Map();
function adtArea(map, x, y) {
  if (!MAPDIR[map]) return 0;
  const fx = 32 - y / TILE, fy = 32 - x / TILE; // Kachel-x aus Welt-Y, Kachel-y aus Welt-X
  const tx = Math.floor(fx), ty = Math.floor(fy);
  const cx = Math.floor((fx - tx) * 16), cy = Math.floor((fy - ty) * 16);
  const name = `World\\Maps\\${MAPDIR[map]}\\${MAPDIR[map]}_${tx}_${ty}.adt`;
  if (!adtCache.has(name)) adtCache.set(name, readFromChain(adtChain, name));
  const buf = adtCache.get(name);
  if (!buf) return 0;
  for (let off = 0; off + 8 <= buf.length;) {
    const id = buf.toString('latin1', off, off + 4), sz = buf.readUInt32LE(off + 4);
    if (id === 'KNCM') {
      const h = off + 8;
      if (buf.readUInt32LE(h + 4) === cx && buf.readUInt32LE(h + 8) === cy) return buf.readUInt32LE(h + 0x34);
    }
    off += 8 + sz;
  }
  return 0;
}

for (const [entry, guid, map, x, y, z, phase] of spawnRows) {
  const t = byEntry.get(+entry);
  if (!t) continue;
  t.spawns.push({ guid: +guid, map: +map, x: +x, y: +y, z: +z, phase: +phase, adtArea: adtArea(+map, +x, +y) });
}
for (const t of trainers) t.spawns.sort((a, b) => a.guid - b.guid);
trainers.sort((a, b) => a.entry - b.entry);

// --- FactionTemplate.dbc: 0 ID, 1 Faction, 2 Flags, 3 ourMask, 4 friendMask, 5 enemyMask --------
const ftRows = new Map(dbc(de, 'FactionTemplate.dbc').rows.map((r) => [r[0], r]));
const factionTemplates = {};
for (const t of trainers) {
  const r = ftRows.get(t.faction);
  if (r) factionTemplates[t.faction] = { our: r[3], friend: r[4], enemy: r[5] };
}

// --- AreaTable.dbc: 0 ID, 1 Map, 2 ParentArea, Namen ab Feld 11 (16 Locale-Slots) ----------------
const areaTable = (chain) => {
  const d = dbc(chain, 'AreaTable.dbc');
  const out = new Map();
  for (const r of d.rows) {
    let name = '';
    for (let k = 11; k < 27; k++) if (r[k]) { name = d.str(r[k]); if (name) break; }
    out.set(r[0], { parent: r[2], name });
  }
  return out;
};
const atDe = areaTable(de), atEn = areaTable(en);

// --- WorldMapArea.dbc: 0 ID, 1 Map, 2 AreaID, 3 MapFile, 4 left, 5 right, 6 top, 7 bottom, 8 DisplayMapID
const CONT = { 1: 1, 0: 2, 530: 3, 571: 4 };
const wma = dbc(de, 'WorldMapArea.dbc');
const zones = {};
for (const r of wma.rows) {
  const map = i32(r[1]), area = r[2], disp = i32(r[8]);
  if (!(map in CONT) || !area) continue;
  const file = wma.str(r[3]);
  zones[file] = {
    wma: r[0], areaId: area, worldMap: map, c: CONT[disp === -1 ? map : disp],
    left: f32(r[4]), right: f32(r[5]), top: f32(r[6]), bottom: f32(r[7]),
  };
}
// Dalaran: WorldMapArea-Grenzen sind 0, Etage 1 steht in DungeonMap.dbc
// (0 ID, 1 Map, 2 Floor, 3 minY, 4 maxY, 5 minX, 6 maxX)
const dm = dbc(de, 'DungeonMap.dbc').rows.find((r) => i32(r[1]) === 571 && i32(r[2]) === 1);
if (zones.Dalaran && dm) {
  Object.assign(zones.Dalaran, { left: f32(dm[4]), right: f32(dm[3]), top: f32(dm[6]), bottom: f32(dm[5]) });
}
for (const z of Object.values(zones)) {
  z.en = (atEn.get(z.areaId) || {}).name || '';
  z.de = (atDe.get(z.areaId) || {}).name || '';
}

// --- Areas: alle von Spawns referenzierten IDs plus Elternkette ----------------------------------
const areas = {};
const addArea = (start) => {
  let id = start;
  while (id && !areas[id]) {
    const e = atEn.get(id), d = atDe.get(id);
    if (!e) break;
    areas[id] = { parent: e.parent, en: e.name, de: d ? d.name : '' };
    id = e.parent;
  }
};
for (const t of trainers) for (const s of t.spawns) addArea(s.adtArea);

// --- Lua-Ausgabe (deterministisch, ASCII; Nicht-ASCII als \ddd) ----------------------------------
const q = (s) => '"' + Array.from(Buffer.from(String(s), 'utf8')).map((b) => {
  if (b === 0x22) return '\\"';
  if (b === 0x5c) return '\\\\';
  if (b < 0x20 || b > 0x7e) return '\\' + b;
  return String.fromCharCode(b);
}).join('') + '"';
const n2 = (v) => {
  const s = (Math.round(v * 100) / 100).toFixed(2);
  return s.replace(/0+$/, '').replace(/\.$/, '');
};
const n4 = (v) => v.toFixed(4);
const num = (a, b) => a - b;

const out = [];
out.push('-- ProfessionPilot Tools/data/trainer_source.lua');
out.push('-- Rohdaten fuer Tools/gen_trainers.lua. Erzeugt von Tools/trainers/extract.mjs aus der');
out.push('-- TrinityCore-3.3.5-Welt-DB (q_trainers.sql, q_spawns.sql) und den Client-DBC/ADT-Dateien.');
out.push('-- Nicht von Hand aendern.');
out.push('return {');
out.push('    factionTemplates = {');
for (const id of Object.keys(factionTemplates).map(Number).sort(num)) {
  const f = factionTemplates[id];
  out.push(`        [${id}] = { our = ${f.our}, friend = ${f.friend}, enemy = ${f.enemy} },`);
}
out.push('    },');
out.push('    zones = {');
for (const file of Object.keys(zones).sort()) {
  const z = zones[file];
  out.push(`        [${q(file)}] = { wma = ${z.wma}, areaId = ${z.areaId}, worldMap = ${z.worldMap}, c = ${z.c}, `
    + `left = ${n4(z.left)}, right = ${n4(z.right)}, top = ${n4(z.top)}, bottom = ${n4(z.bottom)}, `
    + `en = ${q(z.en)}, de = ${q(z.de)} },`);
}
out.push('    },');
out.push('    areas = {');
for (const id of Object.keys(areas).map(Number).sort(num)) {
  const a = areas[id];
  out.push(`        [${id}] = { parent = ${a.parent}, en = ${q(a.en)}, de = ${q(a.de)} },`);
}
out.push('    },');
out.push('    trainers = {');
for (const t of trainers) {
  const rs = t.rankSpells.map(([s, l]) => `{ ${s}, ${l} }`).join(', ');
  out.push(`        { entry = ${t.entry}, name = ${q(t.name)}, sub = ${q(t.sub)}, nameDe = ${q(t.nameDe)}, `
    + `subDe = ${q(t.subDe)}, faction = ${t.faction}, skillLine = ${t.skillLine}, rankSpells = { ${rs} },`);
  out.push('          spawns = {');
  for (const s of t.spawns) {
    out.push(`              { guid = ${s.guid}, map = ${s.map}, x = ${n2(s.x)}, y = ${n2(s.y)}, z = ${n2(s.z)}, `
      + `phase = ${s.phase}, adtArea = ${s.adtArea} },`);
  }
  out.push('          } },');
}
out.push('    },');
out.push('}');
fs.writeFileSync(OUT, out.join('\n') + '\n');
console.error(`trainer_source: ${trainers.length} Lehrer, ${spawnRows.length} Spawns, `
  + `${Object.keys(zones).length} Zonen, ${Object.keys(areas).length} Areas -> ${OUT}`);
