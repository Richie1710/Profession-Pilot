-- ProfessionPilot: Spawns der Berufslehrer (nur Lesen).
-- Ausgabe (TSV, ohne Kopfzeile): entry, guid, map, x, y, z, phaseMask.
-- Bewusst KEIN Filter auf map/phaseMask: das entscheidet Tools/trainer_gen_lib.lua (ValidSpawn, getestet).
SELECT c.id AS entry, c.guid, c.map,
       ROUND(c.position_x, 2) AS x, ROUND(c.position_y, 2) AS y, ROUND(c.position_z, 2) AS z,
       c.phaseMask
FROM creature c
JOIN creature_default_trainer cdt ON cdt.CreatureId = c.id
JOIN trainer t ON t.Id = cdt.TrainerId AND t.Type = 2
WHERE EXISTS (SELECT 1 FROM trainer_spell s
              WHERE s.TrainerId = t.Id
                AND s.ReqSkillLine IN (164,165,171,197,202,333,755,773))
ORDER BY c.id, c.guid;
