// Minimaler MPQ-Leser (v1, zlib) und DBC-Parser fuer den 3.3.5a-Client.
// Nur Node-Bordmittel, keine Zusatzpakete. Wird von extract.mjs benutzt.
import fs from 'fs';
import zlib from 'zlib';

const crypt = new Uint32Array(0x500);
{
  let seed = 0x00100001;
  for (let i = 0; i < 0x100; i++) {
    for (let j = i, k = 0; k < 5; k++, j += 0x100) {
      seed = (seed * 125 + 3) % 0x2AAAAB; const t1 = (seed & 0xFFFF) << 16;
      seed = (seed * 125 + 3) % 0x2AAAAB; const t2 = seed & 0xFFFF;
      crypt[j] = (t1 | t2) >>> 0;
    }
  }
}

function hash(str, type) {
  let s1 = 0x7FED7FED, s2 = 0xEEEEEEEE;
  for (const ch of str.toUpperCase()) {
    const c = ch.charCodeAt(0);
    s1 = (crypt[(type << 8) + c] ^ ((s1 + s2) >>> 0)) >>> 0;
    s2 = (c + s1 + s2 + (s2 << 5) + 3) >>> 0;
  }
  return s1 >>> 0;
}

function decrypt(buf, key) {
  let s2 = 0xEEEEEEEE;
  for (let i = 0; i + 4 <= buf.length; i += 4) {
    s2 = (s2 + crypt[0x400 + (key & 0xFF)]) >>> 0;
    const v = (buf.readUInt32LE(i) ^ ((key + s2) >>> 0)) >>> 0;
    key = ((((~key << 0x15) >>> 0) + 0x11111111) >>> 0 | (key >>> 0x0B)) >>> 0;
    s2 = (v + s2 + (s2 << 5) + 3) >>> 0;
    buf.writeUInt32LE(v, i);
  }
}

export class Mpq {
  constructor(path) {
    this.path = path;
    this.fd = fs.openSync(path, 'r');
    const size = fs.fstatSync(this.fd).size;
    let base = -1;
    for (let off = 0; off < size; off += 512) {
      if (this.rd(off, 4).toString('latin1') === 'MPQ\x1a') { base = off; break; }
    }
    if (base < 0) throw new Error('kein MPQ-Header: ' + path);
    this.base = base;
    const h = this.rd(base, 44);
    this.sectorSize = 512 << h.readUInt16LE(14);
    this.hashN = h.readUInt32LE(24);
    const blockN = h.readUInt32LE(28);
    this.ht = this.rd(base + h.readUInt32LE(16), this.hashN * 16); decrypt(this.ht, hash('(hash table)', 3));
    this.bt = this.rd(base + h.readUInt32LE(20), blockN * 16); decrypt(this.bt, hash('(block table)', 3));
  }

  rd(pos, len) { const b = Buffer.alloc(len); fs.readSync(this.fd, b, 0, len, pos); return b; }

  get(name) {
    const i0 = hash(name, 0) % this.hashN, a = hash(name, 1), b = hash(name, 2);
    let blk = -1;
    for (let k = 0; k < this.hashN; k++) {
      const o = ((i0 + k) % this.hashN) * 16;
      const bi = this.ht.readUInt32LE(o + 12);
      if (bi === 0xFFFFFFFF) break;
      if (this.ht.readUInt32LE(o) === a && this.ht.readUInt32LE(o + 4) === b && bi !== 0xFFFFFFFE) { blk = bi; break; }
    }
    if (blk < 0) return null;
    const o = blk * 16;
    const fp = this.bt.readUInt32LE(o), cs = this.bt.readUInt32LE(o + 4);
    const fsz = this.bt.readUInt32LE(o + 8), fl = this.bt.readUInt32LE(o + 12);
    if (!(fl & 0x80000000)) return null;   // nicht vorhanden
    if (fl & 0x02000000) return null;      // Loeschmarke
    if (fl & 0x10000) throw new Error('verschluesselte Datei nicht unterstuetzt: ' + name);
    const raw = this.rd(this.base + fp, cs);
    const dec = (d, outLen) => {
      if (d.length >= outLen) return d.subarray(0, outLen);
      if (d[0] === 0x02) return zlib.inflateSync(d.subarray(1));
      throw new Error('Kompression 0x' + d[0].toString(16) + ' in ' + name);
    };
    if (!(fl & 0x200)) return raw.subarray(0, fsz);
    if (fl & 0x1000000) return dec(raw, fsz);
    const n = Math.ceil(fsz / this.sectorSize);
    const parts = [];
    for (let s = 0; s < n; s++) {
      const st = raw.readUInt32LE(s * 4), en = raw.readUInt32LE(s * 4 + 4);
      parts.push(dec(raw.subarray(st, en), Math.min(this.sectorSize, fsz - s * this.sectorSize)));
    }
    return Buffer.concat(parts);
  }
}

// Archivkette: spaeter in der Liste gewinnt. Nicht vorhandene Archive werden uebersprungen.
export function openChain(paths) {
  const out = [];
  for (const p of paths) {
    if (!fs.existsSync(p)) continue;
    try { out.push(new Mpq(p)); } catch (e) { process.stderr.write('skip ' + p + ': ' + e.message + '\n'); }
  }
  return out;
}

export function readFromChain(chain, name) {
  let found = null;
  for (const m of chain) { const b = m.get(name); if (b) found = b; }
  return found;
}

// DBC (WDBC): rows = Arrays aus u32, str(off) liest den String-Block, f32(u) deutet u32 als float.
export function parseDbc(buf) {
  if (!buf || buf.toString('latin1', 0, 4) !== 'WDBC') throw new Error('kein WDBC');
  const n = buf.readUInt32LE(4), fc = buf.readUInt32LE(8), rs = buf.readUInt32LE(12);
  const so = 20 + n * rs;
  const rows = [];
  for (let i = 0; i < n; i++) {
    const o = 20 + i * rs; const r = [];
    for (let j = 0; j < fc; j++) r.push(buf.readUInt32LE(o + j * 4));
    rows.push(r);
  }
  const str = (off) => { let e = so + off; while (buf[e]) e++; return buf.toString('utf8', so + off, e); };
  return { rows, str, fc };
}

const dv = new DataView(new ArrayBuffer(4));
export function f32(u) { dv.setUint32(0, u, true); return dv.getFloat32(0, true); }
export function i32(u) { return u | 0; }
