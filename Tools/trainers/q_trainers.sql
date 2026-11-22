-- ProfessionPilot: Berufslehrer aus der TrinityCore-3.3.5-Welt-DB (nur Lesen).
-- Schema trainer / trainer_spell / creature_default_trainer (kein npc_trainer).
-- Ausgabe (TSV, ohne Kopfzeile): entry, name, subname, nameDe, subDe, faction (FactionTemplate-ID),
-- skillLine, rankSpells ("SpellId:ReqLevel,..." nur Rang-Lernzauber, leer = Spezialisierungslehrer).
-- Die Zuordnung Spell -> Rang macht Tools/trainer_gen_lib.lua (RANK_SPELLS).
SELECT ct.entry,
       ct.name,
       IFNULL(ct.subname, '') AS subname,
       IFNULL(loc.Name, '') AS nameDe,
       IFNULL(loc.Title, '') AS subDe,
       ct.faction,
       (SELECT MAX(s.ReqSkillLine) FROM trainer_spell s WHERE s.TrainerId = t.Id) AS skillLine,
       IFNULL((SELECT GROUP_CONCAT(CONCAT(s.SpellId, ':', s.ReqLevel) ORDER BY s.SpellId SEPARATOR ',')
               FROM trainer_spell s
               WHERE s.TrainerId = t.Id
                 AND s.SpellId IN (2275,2020,2155,3911,4039,7414,25245,45375,
                                   2280,2021,2154,3912,4040,7415,25246,45376,
                                   3465,3539,3812,3913,4041,7416,28896,45377,
                                   11612,9786,10663,12181,12657,13921,28899,45378,
                                   28597,29845,32550,26791,30351,28030,28901,45379,
                                   51303,51298,51301,51308,61464,51312,51310,45380)), '') AS rankSpells
FROM creature_default_trainer cdt
JOIN trainer t            ON t.Id = cdt.TrainerId AND t.Type = 2      -- 2 = TRAINER_TYPE_TRADESKILLS
JOIN creature_template ct ON ct.entry = cdt.CreatureId
LEFT JOIN creature_template_locale loc ON loc.entry = ct.entry AND loc.locale = 'deDE'
WHERE EXISTS (SELECT 1 FROM trainer_spell s
              WHERE s.TrainerId = t.Id
                AND s.ReqSkillLine IN (164,165,171,197,202,333,755,773))
ORDER BY ct.entry;
