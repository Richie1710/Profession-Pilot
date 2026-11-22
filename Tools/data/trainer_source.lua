-- ProfessionPilot Tools/data/trainer_source.lua
-- Rohdaten fuer Tools/gen_trainers.lua. Erzeugt von Tools/trainers/extract.mjs aus der
-- TrinityCore-3.3.5-Welt-DB (q_trainers.sql, q_spawns.sql) und den Client-DBC/ADT-Dateien.
-- Nicht von Hand aendern.
return {
    factionTemplates = {
        [12] = { our = 2, friend = 2, enemy = 4 },
        [29] = { our = 4, friend = 4, enemy = 2 },
        [35] = { our = 0, friend = 1, enemy = 0 },
        [55] = { our = 2, friend = 2, enemy = 4 },
        [64] = { our = 2, friend = 2, enemy = 4 },
        [68] = { our = 4, friend = 4, enemy = 2 },
        [69] = { our = 0, friend = 0, enemy = 0 },
        [80] = { our = 2, friend = 2, enemy = 4 },
        [104] = { our = 4, friend = 4, enemy = 2 },
        [120] = { our = 0, friend = 0, enemy = 0 },
        [126] = { our = 4, friend = 4, enemy = 2 },
        [189] = { our = 0, friend = 0, enemy = 0 },
        [414] = { our = 8, friend = 0, enemy = 1 },
        [474] = { our = 0, friend = 0, enemy = 0 },
        [694] = { our = 2, friend = 2, enemy = 4 },
        [714] = { our = 4, friend = 4, enemy = 0 },
        [875] = { our = 2, friend = 2, enemy = 4 },
        [894] = { our = 2, friend = 2, enemy = 4 },
        [1604] = { our = 4, friend = 4, enemy = 2 },
        [1638] = { our = 2, friend = 2, enemy = 4 },
        [1667] = { our = 2, friend = 2, enemy = 4 },
        [1669] = { our = 4, friend = 4, enemy = 2 },
        [1671] = { our = 2, friend = 2, enemy = 4 },
        [1685] = { our = 2, friend = 0, enemy = 4 },
        [1729] = { our = 4, friend = 4, enemy = 2 },
        [1731] = { our = 1, friend = 0, enemy = 8 },
        [1733] = { our = 2, friend = 2, enemy = 4 },
        [1735] = { our = 4, friend = 4, enemy = 2 },
        [1737] = { our = 2, friend = 2, enemy = 4 },
        [1743] = { our = 0, friend = 0, enemy = 0 },
        [1744] = { our = 0, friend = 0, enemy = 0 },
        [1818] = { our = 0, friend = 0, enemy = 0 },
        [1892] = { our = 2, friend = 2, enemy = 4 },
        [1922] = { our = 0, friend = 4, enemy = 2 },
        [1928] = { our = 4, friend = 0, enemy = 2 },
        [1978] = { our = 4, friend = 0, enemy = 2 },
        [1981] = { our = 4, friend = 0, enemy = 2 },
        [2007] = { our = 0, friend = 0, enemy = 0 },
        [2070] = { our = 0, friend = 0, enemy = 0 },
    },
    zones = {
        ["Alterac"] = { wma = 15, areaId = 36, worldMap = 0, c = 2, left = 783.3333, right = -2016.6666, top = 1500.0000, bottom = -366.6667, en = "Alterac Mountains", de = "Alteracgebirge" },
        ["Arathi"] = { wma = 16, areaId = 45, worldMap = 0, c = 2, left = -866.6666, right = -4466.6665, top = -133.3333, bottom = -2533.3333, en = "Arathi Highlands", de = "Arathihochland" },
        ["Ashenvale"] = { wma = 43, areaId = 331, worldMap = 1, c = 1, left = 1699.9999, right = -4066.6665, top = 4672.9165, bottom = 829.1666, en = "Ashenvale", de = "Eschental" },
        ["Aszhara"] = { wma = 181, areaId = 16, worldMap = 1, c = 1, left = -3277.0833, right = -8347.9160, top = 5341.6665, bottom = 1960.4166, en = "Azshara", de = "Azshara" },
        ["AzuremystIsle"] = { wma = 464, areaId = 3524, worldMap = 530, c = 1, left = -10500.0000, right = -14570.8330, top = -2793.7500, bottom = -5508.3330, en = "Azuremyst Isle", de = "Azurmythosinsel" },
        ["Badlands"] = { wma = 17, areaId = 3, worldMap = 0, c = 2, left = -2079.1665, right = -4566.6665, top = -5889.5830, bottom = -7547.9165, en = "Badlands", de = "\195\150dland" },
        ["Barrens"] = { wma = 11, areaId = 17, worldMap = 1, c = 1, left = 2622.9165, right = -7510.4165, top = 1612.4999, bottom = -5143.7500, en = "The Barrens", de = "Brachland" },
        ["BladesEdgeMountains"] = { wma = 475, areaId = 3522, worldMap = 530, c = 3, left = 8845.8330, right = 3420.8333, top = 4408.3330, bottom = 791.6666, en = "Blade's Edge Mountains", de = "Schergrat" },
        ["BlastedLands"] = { wma = 19, areaId = 4, worldMap = 0, c = 2, left = -1241.6666, right = -4591.6665, top = -10566.6660, bottom = -12800.0000, en = "Blasted Lands", de = "Verw\195\188stete Lande" },
        ["BloodmystIsle"] = { wma = 476, areaId = 3525, worldMap = 530, c = 1, left = -10075.0000, right = -13337.4990, top = -758.3333, bottom = -2933.3333, en = "Bloodmyst Isle", de = "Blutmythosinsel" },
        ["BoreanTundra"] = { wma = 486, areaId = 3537, worldMap = 571, c = 4, left = 8570.8330, right = 2806.2500, top = 4897.9165, bottom = 1054.1666, en = "Borean Tundra", de = "Boreanische Tundra" },
        ["BurningSteppes"] = { wma = 29, areaId = 46, worldMap = 0, c = 2, left = -266.6667, right = -3195.8333, top = -7031.2495, bottom = -8983.3330, en = "Burning Steppes", de = "Brennende Steppe" },
        ["CrystalsongForest"] = { wma = 510, areaId = 2817, worldMap = 571, c = 4, left = 1443.7500, right = -1279.1666, top = 6502.0830, bottom = 4687.5000, en = "Crystalsong Forest", de = "Kristallsangwald" },
        ["Dalaran"] = { wma = 504, areaId = 4395, worldMap = 571, c = 4, left = 1052.5100, right = 222.4950, top = 6066.6699, bottom = 5513.3301, en = "Dalaran", de = "Dalaran" },
        ["Darkshore"] = { wma = 42, areaId = 148, worldMap = 1, c = 1, left = 2941.6665, right = -3608.3333, top = 8333.3330, bottom = 3966.6665, en = "Darkshore", de = "Dunkelk\195\188ste" },
        ["Darnassis"] = { wma = 381, areaId = 1657, worldMap = 1, c = 1, left = 2938.3628, right = 1880.0295, top = 10238.3164, bottom = 9532.5869, en = "Darnassus", de = "Darnassus" },
        ["DeadwindPass"] = { wma = 32, areaId = 41, worldMap = 0, c = 2, left = -833.3333, right = -3333.3333, top = -9866.6660, bottom = -11533.3330, en = "Deadwind Pass", de = "Gebirgspass der Totenwinde" },
        ["Desolace"] = { wma = 101, areaId = 405, worldMap = 1, c = 1, left = 4233.3330, right = -262.5000, top = 452.0833, bottom = -2545.8333, en = "Desolace", de = "Desolace" },
        ["Dragonblight"] = { wma = 488, areaId = 65, worldMap = 571, c = 4, left = 3627.0833, right = -1981.2499, top = 5575.0000, bottom = 1835.4166, en = "Dragonblight", de = "Drachen\195\182de" },
        ["DunMorogh"] = { wma = 27, areaId = 1, worldMap = 0, c = 2, left = 1802.0833, right = -3122.9165, top = -3877.0833, bottom = -7160.4165, en = "Dun Morogh", de = "Dun Morogh" },
        ["Durotar"] = { wma = 4, areaId = 14, worldMap = 1, c = 1, left = -1962.4999, right = -7249.9995, top = 1808.3333, bottom = -1716.6666, en = "Durotar", de = "Durotar" },
        ["Duskwood"] = { wma = 34, areaId = 10, worldMap = 0, c = 2, left = 833.3333, right = -1866.6666, top = -9716.6660, bottom = -11516.6660, en = "Duskwood", de = "D\195\164mmerwald" },
        ["Dustwallow"] = { wma = 141, areaId = 15, worldMap = 1, c = 1, left = -974.9999, right = -6225.0000, top = -2033.3333, bottom = -5533.3330, en = "Dustwallow Marsh", de = "D\195\188stermarschen" },
        ["EasternPlaguelands"] = { wma = 23, areaId = 139, worldMap = 0, c = 2, left = -2287.5000, right = -6318.7500, top = 3704.1665, bottom = 1016.6666, en = "Eastern Plaguelands", de = "\195\150stliche Pestl\195\164nder" },
        ["Elwynn"] = { wma = 30, areaId = 12, worldMap = 0, c = 2, left = 1535.4166, right = -1935.4166, top = -7939.5830, bottom = -10254.1660, en = "Elwynn Forest", de = "Wald von Elwynn" },
        ["EversongWoods"] = { wma = 462, areaId = 3430, worldMap = 530, c = 2, left = -4487.5000, right = -9412.5000, top = 11041.6660, bottom = 7758.3330, en = "Eversong Woods", de = "Immersangwald" },
        ["Felwood"] = { wma = 182, areaId = 361, worldMap = 1, c = 1, left = 1641.6666, right = -4108.3330, top = 7133.3330, bottom = 3299.9998, en = "Felwood", de = "Teufelswald" },
        ["Feralas"] = { wma = 121, areaId = 357, worldMap = 1, c = 1, left = 5441.6665, right = -1508.3333, top = -2366.6665, bottom = -6999.9995, en = "Feralas", de = "Feralas" },
        ["Ghostlands"] = { wma = 463, areaId = 3433, worldMap = 530, c = 2, left = -5283.3330, right = -8583.3330, top = 8266.6660, bottom = 6066.6665, en = "Ghostlands", de = "Geisterlande" },
        ["GrizzlyHills"] = { wma = 490, areaId = 394, worldMap = 571, c = 4, left = -1110.4166, right = -6360.4165, top = 5516.6665, bottom = 2016.6666, en = "Grizzly Hills", de = "Grizzlyh\195\188gel" },
        ["Hellfire"] = { wma = 465, areaId = 3483, worldMap = 530, c = 3, left = 5539.5830, right = 375.0000, top = 1481.2500, bottom = -1962.4999, en = "Hellfire Peninsula", de = "H\195\182llenfeuerhalbinsel" },
        ["Hilsbrad"] = { wma = 24, areaId = 267, worldMap = 0, c = 2, left = 1066.6666, right = -2133.3333, top = 400.0000, bottom = -1733.3333, en = "Hillsbrad Foothills", de = "Vorgebirge des H\195\188gellands" },
        ["Hinterlands"] = { wma = 26, areaId = 47, worldMap = 0, c = 2, left = -1575.0000, right = -5425.0000, top = 1466.6666, bottom = -1100.0000, en = "The Hinterlands", de = "Hinterland" },
        ["HowlingFjord"] = { wma = 491, areaId = 495, worldMap = 571, c = 4, left = -1397.9166, right = -7443.7495, top = 3116.6665, bottom = -914.5833, en = "Howling Fjord", de = "Der heulende Fjord" },
        ["HrothgarsLanding"] = { wma = 541, areaId = 4742, worldMap = 571, c = 4, left = 2797.9165, right = -879.1666, top = 10781.2500, bottom = 8329.1660, en = "Hrothgar's Landing", de = "Hrothgars Landestelle" },
        ["IcecrownGlacier"] = { wma = 492, areaId = 210, worldMap = 571, c = 4, left = 5443.7500, right = -827.0833, top = 9427.0830, bottom = 5245.8330, en = "Icecrown", de = "Eiskrone" },
        ["Ironforge"] = { wma = 341, areaId = 1537, worldMap = 0, c = 2, left = -713.5914, right = -1504.2164, top = -4569.2412, bottom = -5096.8457, en = "Ironforge", de = "Eisenschmiede" },
        ["LakeWintergrasp"] = { wma = 501, areaId = 4197, worldMap = 571, c = 4, left = 4329.1665, right = 1354.1666, top = 5716.6665, bottom = 3733.3333, en = "Wintergrasp", de = "Tausendwintersee" },
        ["LochModan"] = { wma = 35, areaId = 38, worldMap = 0, c = 2, left = -1993.7499, right = -4752.0830, top = -4487.5000, bottom = -6327.0830, en = "Loch Modan", de = "Loch Modan" },
        ["Moonglade"] = { wma = 241, areaId = 493, worldMap = 1, c = 1, left = -1381.2500, right = -3689.5833, top = 8491.6660, bottom = 6952.0830, en = "Moonglade", de = "Mondlichtung" },
        ["Mulgore"] = { wma = 9, areaId = 215, worldMap = 1, c = 1, left = 2047.9166, right = -3089.5833, top = -272.9167, bottom = -3697.9165, en = "Mulgore", de = "Mulgore" },
        ["Nagrand"] = { wma = 477, areaId = 3518, worldMap = 530, c = 3, left = 10295.8330, right = 4770.8330, top = 41.6667, bottom = -3641.6665, en = "Nagrand", de = "Nagrand" },
        ["Netherstorm"] = { wma = 479, areaId = 3523, worldMap = 530, c = 3, left = 5483.3330, right = -91.6667, top = 5456.2500, bottom = 1739.5833, en = "Netherstorm", de = "Nethersturm" },
        ["Ogrimmar"] = { wma = 321, areaId = 1637, worldMap = 1, c = 1, left = -3680.6011, right = -5083.2056, top = 2273.8772, bottom = 1338.4606, en = "Orgrimmar", de = "Orgrimmar" },
        ["Redridge"] = { wma = 36, areaId = 44, worldMap = 0, c = 2, left = -1570.8333, right = -3741.6665, top = -8575.0000, bottom = -10022.9160, en = "Redridge Mountains", de = "Rotkammgebirge" },
        ["SearingGorge"] = { wma = 28, areaId = 51, worldMap = 0, c = 2, left = -322.9167, right = -2554.1665, top = -6100.0000, bottom = -7587.4995, en = "Searing Gorge", de = "Sengende Schlucht" },
        ["ShadowmoonValley"] = { wma = 473, areaId = 3520, worldMap = 530, c = 3, left = 4225.0000, right = -1275.0000, top = -1947.9166, bottom = -5614.5830, en = "Shadowmoon Valley", de = "Schattenmondtal" },
        ["ShattrathCity"] = { wma = 481, areaId = 3703, worldMap = 530, c = 3, left = 6135.2588, right = 4829.0088, top = -1473.9545, bottom = -2344.7878, en = "Shattrath City", de = "Shattrath" },
        ["SholazarBasin"] = { wma = 493, areaId = 3711, worldMap = 571, c = 4, left = 6929.1665, right = 2572.9165, top = 7287.4995, bottom = 4383.3330, en = "Sholazar Basin", de = "Sholazarbecken" },
        ["Silithus"] = { wma = 261, areaId = 1377, worldMap = 1, c = 1, left = 2537.5000, right = -945.8340, top = -5958.3340, bottom = -8281.2500, en = "Silithus", de = "Silithus" },
        ["SilvermoonCity"] = { wma = 480, areaId = 3487, worldMap = 530, c = 2, left = -6400.7500, right = -7612.2085, top = 10153.7090, bottom = 9346.9385, en = "Silvermoon City", de = "Silbermond" },
        ["Silverpine"] = { wma = 21, areaId = 130, worldMap = 0, c = 2, left = 3449.9998, right = -750.0000, top = 1666.6666, bottom = -1133.3333, en = "Silverpine Forest", de = "Silberwald" },
        ["StonetalonMountains"] = { wma = 81, areaId = 406, worldMap = 1, c = 1, left = 3245.8333, right = -1637.4999, top = 2916.6665, bottom = -339.5833, en = "Stonetalon Mountains", de = "Steinkrallengebirge" },
        ["Stormwind"] = { wma = 301, areaId = 1519, worldMap = 0, c = 2, left = 1722.9166, right = -14.5833, top = -7995.8330, bottom = -9154.1660, en = "Stormwind City", de = "Sturmwind" },
        ["Stranglethorn"] = { wma = 37, areaId = 33, worldMap = 0, c = 2, left = 2220.8333, right = -4160.4165, top = -11168.7500, bottom = -15422.9160, en = "Stranglethorn Vale", de = "Schlingendorntal" },
        ["Sunwell"] = { wma = 499, areaId = 4080, worldMap = 530, c = 2, left = -5302.0830, right = -8629.1660, top = 13568.7490, bottom = 11350.0000, en = "Isle of Quel'Danas", de = "Insel von Quel'Danas" },
        ["SwampOfSorrows"] = { wma = 38, areaId = 8, worldMap = 0, c = 2, left = -2222.9165, right = -4516.6665, top = -9620.8330, bottom = -11150.0000, en = "Swamp of Sorrows", de = "S\195\188mpfe des Elends" },
        ["Tanaris"] = { wma = 161, areaId = 440, worldMap = 1, c = 1, left = -218.7500, right = -7118.7495, top = -5875.0000, bottom = -10475.0000, en = "Tanaris", de = "Tanaris" },
        ["Teldrassil"] = { wma = 41, areaId = 141, worldMap = 1, c = 1, left = 3814.5833, right = -1277.0833, top = 11831.2500, bottom = 8437.5000, en = "Teldrassil", de = "Teldrassil" },
        ["TerokkarForest"] = { wma = 478, areaId = 3519, worldMap = 530, c = 3, left = 7083.3330, right = 1683.3333, top = -999.9999, bottom = -4600.0000, en = "Terokkar Forest", de = "W\195\164lder von Terokkar" },
        ["TheExodar"] = { wma = 471, areaId = 3557, worldMap = 530, c = 1, left = -11066.3672, right = -12123.1377, top = -3609.6833, bottom = -4314.3711, en = "The Exodar", de = "Die Exodar" },
        ["TheStormPeaks"] = { wma = 495, areaId = 67, worldMap = 571, c = 4, left = 1841.6666, right = -5270.8330, top = 10197.9160, bottom = 5456.2500, en = "The Storm Peaks", de = "Die Sturmgipfel" },
        ["ThousandNeedles"] = { wma = 61, areaId = 400, worldMap = 1, c = 1, left = -433.3333, right = -4833.3330, top = -3966.6665, bottom = -6899.9995, en = "Thousand Needles", de = "Tausend Nadeln" },
        ["ThunderBluff"] = { wma = 362, areaId = 1638, worldMap = 1, c = 1, left = 516.6666, right = -527.0833, top = -849.9999, bottom = -1545.8333, en = "Thunder Bluff", de = "Donnerfels" },
        ["Tirisfal"] = { wma = 20, areaId = 85, worldMap = 0, c = 2, left = 3033.3333, right = -1485.4166, top = 3837.4998, bottom = 824.9999, en = "Tirisfal Glades", de = "Tirisfal" },
        ["Undercity"] = { wma = 382, areaId = 1497, worldMap = 0, c = 2, left = 873.1926, right = -86.1824, top = 1877.9453, bottom = 1237.8412, en = "Undercity", de = "Unterstadt" },
        ["UngoroCrater"] = { wma = 201, areaId = 490, worldMap = 1, c = 1, left = 533.3333, right = -3166.6665, top = -5966.6665, bottom = -8433.3330, en = "Un'Goro Crater", de = "Krater von Un'Goro" },
        ["WesternPlaguelands"] = { wma = 22, areaId = 28, worldMap = 0, c = 2, left = 416.6667, right = -3883.3333, top = 3366.6665, bottom = 500.0000, en = "Western Plaguelands", de = "Westliche Pestl\195\164nder" },
        ["Westfall"] = { wma = 39, areaId = 40, worldMap = 0, c = 2, left = 3016.6665, right = -483.3333, top = -9400.0000, bottom = -11733.3330, en = "Westfall", de = "Westfall" },
        ["Wetlands"] = { wma = 40, areaId = 11, worldMap = 0, c = 2, left = -389.5833, right = -4525.0000, top = -2147.9165, bottom = -4904.1665, en = "Wetlands", de = "Sumpfland" },
        ["Winterspring"] = { wma = 281, areaId = 618, worldMap = 1, c = 1, left = -316.6667, right = -7416.6665, top = 8533.3330, bottom = 3799.9998, en = "Winterspring", de = "Winterquell" },
        ["Zangarmarsh"] = { wma = 467, areaId = 3521, worldMap = 530, c = 3, left = 9475.0000, right = 4447.9165, top = 1935.4166, bottom = -1416.6666, en = "Zangarmarsh", de = "Zangarmarschen" },
        ["ZulDrak"] = { wma = 496, areaId = 66, worldMap = 571, c = 4, left = -600.0000, right = -5593.7500, top = 7668.7495, bottom = 4339.5830, en = "Zul'Drak", de = "Zul'Drak" },
    },
    areas = {
        [1] = { parent = 0, en = "Dun Morogh", de = "Dun Morogh" },
        [3] = { parent = 0, en = "Badlands", de = "\195\150dland" },
        [8] = { parent = 0, en = "Swamp of Sorrows", de = "S\195\188mpfe des Elends" },
        [10] = { parent = 0, en = "Duskwood", de = "D\195\164mmerwald" },
        [12] = { parent = 0, en = "Elwynn Forest", de = "Wald von Elwynn" },
        [14] = { parent = 0, en = "Durotar", de = "Durotar" },
        [15] = { parent = 0, en = "Dustwallow Marsh", de = "D\195\188stermarschen" },
        [16] = { parent = 0, en = "Azshara", de = "Azshara" },
        [17] = { parent = 0, en = "The Barrens", de = "Brachland" },
        [33] = { parent = 0, en = "Stranglethorn Vale", de = "Schlingendorntal" },
        [35] = { parent = 33, en = "Booty Bay", de = "Beutebucht" },
        [38] = { parent = 0, en = "Loch Modan", de = "Loch Modan" },
        [42] = { parent = 10, en = "Darkshire", de = "Dunkelhain" },
        [45] = { parent = 0, en = "Arathi Highlands", de = "Arathihochland" },
        [47] = { parent = 0, en = "The Hinterlands", de = "Hinterland" },
        [51] = { parent = 0, en = "Searing Gorge", de = "Sengende Schlucht" },
        [65] = { parent = 0, en = "Dragonblight", de = "Drachen\195\182de" },
        [67] = { parent = 0, en = "The Storm Peaks", de = "Die Sturmgipfel" },
        [75] = { parent = 8, en = "Stonard", de = "Steinard" },
        [85] = { parent = 0, en = "Tirisfal Glades", de = "Tirisfal" },
        [87] = { parent = 12, en = "Goldshire", de = "Goldhain" },
        [88] = { parent = 12, en = "Eastvale Logging Camp", de = "Holzf\195\164llerlager des Osttals" },
        [91] = { parent = 12, en = "Tower of Azora", de = "Turm von Azora" },
        [117] = { parent = 33, en = "Grom'gol Base Camp", de = "Basislager von Grom'gol" },
        [130] = { parent = 0, en = "Silverpine Forest", de = "Silberwald" },
        [131] = { parent = 1, en = "Kharanos", de = "Kharanos" },
        [141] = { parent = 0, en = "Teldrassil", de = "Teldrassil" },
        [144] = { parent = 38, en = "Thelsamar", de = "Thelsamar" },
        [146] = { parent = 38, en = "Stonewrought Dam", de = "Der Steinwerkdamm" },
        [148] = { parent = 0, en = "Darkshore", de = "Dunkelk\195\188ste" },
        [153] = { parent = 85, en = "Ruins of Lordaeron", de = "Ruinen von Lordaeron" },
        [159] = { parent = 85, en = "Brill", de = "Brill" },
        [166] = { parent = 85, en = "Cold Hearth Manor", de = "Das verlassene Anwesen" },
        [186] = { parent = 141, en = "Dolanaar", de = "Dolanaar" },
        [189] = { parent = 1, en = "Steelgrill's Depot", de = "Stahlrosts Depot" },
        [210] = { parent = 0, en = "Icecrown", de = "Eiskrone" },
        [215] = { parent = 0, en = "Mulgore", de = "Mulgore" },
        [222] = { parent = 215, en = "Bloodhoof Village", de = "Dorf der Bluthufe" },
        [228] = { parent = 130, en = "The Sepulcher", de = "Das Grabmal" },
        [264] = { parent = 141, en = "The Oracle Glade", de = "Die Lichtung des Orakels" },
        [267] = { parent = 0, en = "Hillsbrad Foothills", de = "Vorgebirge des H\195\188gellands" },
        [272] = { parent = 267, en = "Tarren Mill", de = "Tarrens M\195\188hle" },
        [331] = { parent = 0, en = "Ashenvale", de = "Eschental" },
        [349] = { parent = 47, en = "Wildhammer Keep", de = "Burg Wildhammer" },
        [357] = { parent = 0, en = "Feralas", de = "Feralas" },
        [361] = { parent = 0, en = "Felwood", de = "Teufelswald" },
        [362] = { parent = 14, en = "Razor Hill", de = "Klingenh\195\188gel" },
        [367] = { parent = 14, en = "Sen'jin Village", de = "Sen'jin" },
        [378] = { parent = 17, en = "Camp Taurajo", de = "Camp Taurajo" },
        [380] = { parent = 17, en = "The Crossroads", de = "Das Wegekreuz" },
        [392] = { parent = 17, en = "Ratchet", de = "Ratschet" },
        [405] = { parent = 0, en = "Desolace", de = "Desolace" },
        [406] = { parent = 0, en = "Stonetalon Mountains", de = "Steinkrallengebirge" },
        [415] = { parent = 331, en = "Astranaar", de = "Astranaar" },
        [420] = { parent = 331, en = "Silverwind Refuge", de = "Silberwindzuflucht" },
        [440] = { parent = 0, en = "Tanaris", de = "Tanaris" },
        [442] = { parent = 148, en = "Auberdine", de = "Auberdine" },
        [460] = { parent = 406, en = "Sun Rock Retreat", de = "Sonnenfels" },
        [489] = { parent = 357, en = "Thalanaar", de = "Thalanaar" },
        [495] = { parent = 0, en = "Howling Fjord", de = "Der heulende Fjord" },
        [513] = { parent = 15, en = "Theramore Isle", de = "Die Insel Theramore" },
        [597] = { parent = 405, en = "Ghost Walker Post", de = "Geistwandlerposten" },
        [976] = { parent = 440, en = "Gadgetzan", de = "Gadgetzan" },
        [1099] = { parent = 357, en = "Camp Mojache", de = "Camp Mojache" },
        [1116] = { parent = 357, en = "Feathermoon Stronghold", de = "Mondfederfeste" },
        [1221] = { parent = 16, en = "Ruins of Eldarath", de = "Die Ruinen von Eldarath" },
        [1519] = { parent = 0, en = "Stormwind City", de = "Sturmwind" },
        [1637] = { parent = 0, en = "Orgrimmar", de = "Orgrimmar" },
        [1638] = { parent = 0, en = "Thunder Bluff", de = "Donnerfels" },
        [1640] = { parent = 1638, en = "Spirit Rise", de = "Die Anh\195\182he der Geister" },
        [1657] = { parent = 0, en = "Darnassus", de = "Darnassus" },
        [1659] = { parent = 1657, en = "Craftsmen's Terrace", de = "Die Terrasse der Handwerker" },
        [1958] = { parent = 51, en = "Tanner Camp", de = "Gerbers Lager" },
        [2817] = { parent = 0, en = "Crystalsong Forest", de = "Kristallsangwald" },
        [3430] = { parent = 0, en = "Eversong Woods", de = "Immersangwald" },
        [3464] = { parent = 3430, en = "Farstrider Retreat", de = "Zuflucht der Weltenwanderer" },
        [3468] = { parent = 3430, en = "Saltheril's Haven", de = "Saltherils Hafen" },
        [3479] = { parent = 0, en = "The Veiled Sea", de = "Das verh\195\188llte Meer" },
        [3483] = { parent = 0, en = "Hellfire Peninsula", de = "H\195\182llenfeuerhalbinsel" },
        [3487] = { parent = 0, en = "Silvermoon City", de = "Silbermond" },
        [3520] = { parent = 0, en = "Shadowmoon Valley", de = "Schattenmondtal" },
        [3521] = { parent = 0, en = "Zangarmarsh", de = "Zangarmarschen" },
        [3522] = { parent = 0, en = "Blade's Edge Mountains", de = "Schergrat" },
        [3523] = { parent = 0, en = "Netherstorm", de = "Nethersturm" },
        [3524] = { parent = 0, en = "Azuremyst Isle", de = "Azurmythosinsel" },
        [3536] = { parent = 3483, en = "Thrallmar", de = "Thrallmar" },
        [3537] = { parent = 0, en = "Borean Tundra", de = "Boreanische Tundra" },
        [3538] = { parent = 3483, en = "Honor Hold", de = "Ehrenfeste" },
        [3557] = { parent = 0, en = "The Exodar", de = "Die Exodar" },
        [3572] = { parent = 3524, en = "Stillpine Hold", de = "Tannenruhfeste" },
        [3573] = { parent = 3524, en = "Odesyus' Landing", de = "Odesyus' Ankerplatz" },
        [3576] = { parent = 3524, en = "Azure Watch", de = "Azurwacht" },
        [3580] = { parent = 3524, en = "Wildwind Peak", de = "Wildwindgipfel" },
        [3644] = { parent = 3521, en = "Telredor", de = "Telredor" },
        [3665] = { parent = 3430, en = "Falconwing Square", de = "Falkenplatz" },
        [3703] = { parent = 0, en = "Shattrath City", de = "Shattrath" },
        [3712] = { parent = 3523, en = "Area 52", de = "Area 52" },
        [3738] = { parent = 3523, en = "The Stormspire", de = "Die Sturms\195\164ule" },
        [3744] = { parent = 3520, en = "Shadowmoon Village", de = "Schattenmond" },
        [3745] = { parent = 3520, en = "Wildhammer Stronghold", de = "Wildhammerfeste" },
        [3833] = { parent = 3522, en = "Razor Ridge", de = "Messergrat" },
        [3844] = { parent = 3522, en = "Mok'Nathal Village", de = "Dorf der Mok'Nathal" },
        [3896] = { parent = 3703, en = "Aldor Rise", de = "Aldorh\195\182he" },
        [3898] = { parent = 3703, en = "Scryer's Tier", de = "Sehertreppe" },
        [3899] = { parent = 3703, en = "Lower City", de = "Unteres Viertel" },
        [3981] = { parent = 495, en = "Valgarde", de = "Valgarde" },
        [4000] = { parent = 495, en = "Vengeance Landing", de = "Hafen der Vergeltung" },
        [4032] = { parent = 3537, en = "Valiance Keep", de = "Valianzfeste" },
        [4037] = { parent = 3537, en = "Taunka'le Village", de = "Taunka'le" },
        [4129] = { parent = 3537, en = "Warsong Hold", de = "Kriegshymnenfeste" },
        [4165] = { parent = 65, en = "Agmar's Hammer", de = "Agmars Hammer" },
        [4186] = { parent = 65, en = "Venomspite", de = "Gallgrimm" },
        [4428] = { parent = 67, en = "Frosthold", de = "Eisfestung" },
        [4553] = { parent = 2817, en = "Forlorn Woods", de = "Die trostlosen W\195\164lder" },
        [4658] = { parent = 210, en = "Argent Tournament Grounds", de = "Argentumturnierplatz" },
    },
    trainers = {
        { entry = 514, name = "Smith Argus", sub = "Blacksmithing Trainer", nameDe = "Schmied Argus", subDe = "Schmiedekunstlehrer", faction = 12, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 80336, map = 0, x = -9456.65, y = 87.86, z = 58.43, phase = 1, adtArea = 87 },
          } },
        { entry = 1103, name = "Eldrin", sub = "Tailoring Trainer", nameDe = "Eldrin", subDe = "Schneiderlehrer", faction = 12, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 81239, map = 0, x = -9537.24, y = -1214.05, z = 48.23, phase = 1, adtArea = 88 },
          } },
        { entry = 1215, name = "Alchemist Mallory", sub = "Alchemy Trainer", nameDe = "Alchemist Mallory", subDe = "Alchemielehrer", faction = 12, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 11, map = 0, x = -9056, y = 152.63, z = 115.12, phase = 1, adtArea = 12 },
          } },
        { entry = 1241, name = "Tognus Flintfire", sub = "Blacksmithing Trainer", nameDe = "Tognus Funkenfeuer", subDe = "Schmiedekunstlehrer", faction = 55, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 213, map = 0, x = -5582.41, y = -430.97, z = 397.33, phase = 1, adtArea = 131 },
          } },
        { entry = 1317, name = "Lucan Cordell", sub = "Enchanting Trainer", nameDe = "Lucan Cordell", subDe = "Verzauberkunstlehrer", faction = 12, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 79828, map = 0, x = -8858.31, y = 803.73, z = 96.52, phase = 1, adtArea = 1519 },
          } },
        { entry = 1346, name = "Georgio Bolero", sub = "Tailoring Trainer", nameDe = "Georgio Bolero", subDe = "Schneiderlehrer", faction = 12, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 79826, map = 0, x = -8938.1, y = 800.71, z = 91.03, phase = 1, adtArea = 1519 },
          } },
        { entry = 1385, name = "Brawn", sub = "Leatherworking Trainer", nameDe = "Brawn", subDe = "Lederverarbeitungslehrer", faction = 29, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 662, map = 0, x = -12398.2, y = 195.15, z = 2.43, phase = 1, adtArea = 117 },
          } },
        { entry = 1386, name = "Rogvar", sub = "Alchemy Trainer", nameDe = "Rogvar", subDe = "Alchemielehrer", faction = 29, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 31950, map = 0, x = -10474.8, y = -3335.97, z = 25.55, phase = 1, adtArea = 75 },
          } },
        { entry = 1470, name = "Ghak Healtouch", sub = "Alchemy Trainer", nameDe = "Ghak Heilsegen", subDe = "Alchemielehrer", faction = 55, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 8222, map = 0, x = -5395.86, y = -3016.18, z = 327.66, phase = 1, adtArea = 144 },
          } },
        { entry = 1632, name = "Adele Fielder", sub = "Leatherworking Trainer", nameDe = "Adele F\195\164dler", subDe = "Lederverarbeitungslehrerin", faction = 12, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 81093, map = 0, x = -9375.68, y = -74.48, z = 64.52, phase = 1, adtArea = 87 },
          } },
        { entry = 1676, name = "Finbus Geargrind", sub = "Engineering Trainer", nameDe = "Finbus Ritzelschleifer", subDe = "Ingenieurslehrer", faction = 875, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 4081, map = 0, x = -10595.5, y = -1255.96, z = 37.47, phase = 1, adtArea = 42 },
          } },
        { entry = 1702, name = "Bronk Guzzlegear", sub = "Engineering Trainer", nameDe = "Bronk Muffenschlinger", subDe = "Ingenieurslehrer", faction = 55, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 4091, map = 0, x = -5531.17, y = -669.07, z = 393.41, phase = 1, adtArea = 189 },
          } },
        { entry = 2132, name = "Carolai Anise", sub = "Alchemy Trainer", nameDe = "Carolai Anise", subDe = "Alchemielehrerin", faction = 68, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 33708, map = 0, x = 2265.17, y = 347.63, z = 36.1, phase = 1, adtArea = 159 },
          } },
        { entry = 2391, name = "Serge Hinott", sub = "Alchemy Trainer", nameDe = "Serge Hinott", subDe = "Alchemielehrer", faction = 68, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 15293, map = 0, x = -9.29, y = -905.47, z = 57.56, phase = 1, adtArea = 272 },
          } },
        { entry = 2399, name = "Daryl Stack", sub = "Tailoring Trainer", nameDe = "Daryl Ballen", subDe = "Schneiderlehrer", faction = 68, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 15286, map = 0, x = -43.43, y = -973.3, z = 56.97, phase = 1, adtArea = 272 },
          } },
        { entry = 2627, name = "Grarnik Goodstitch", sub = "Tailoring Trainer", nameDe = "Grarnik Gutstich", subDe = "Schneiderlehrer", faction = 120, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 638, map = 0, x = -14437.8, y = 384.77, z = 32.4, phase = 1, adtArea = 35 },
          } },
        { entry = 2836, name = "Brikk Keencraft", sub = "Blacksmithing Trainer", nameDe = "Brikk K\195\188hnwerk", subDe = "Schmiedekunstlehrer", faction = 120, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 637, map = 0, x = -14383, y = 370.77, z = 24.01, phase = 1, adtArea = 35 },
          } },
        { entry = 2837, name = "Jaxin Chong", sub = "Alchemy Trainer", nameDe = "Jaxin Chong", subDe = "Alchemielehrer", faction = 120, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 640, map = 0, x = -14486.7, y = 431.51, z = 34.67, phase = 1, adtArea = 35 },
          } },
        { entry = 2998, name = "Karn Stonehoof", sub = "Blacksmithing Trainer", nameDe = "Karn Steinhuf", subDe = "Schmiedekunstlehrer", faction = 104, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 26618, map = 1, x = -1233.33, y = 105.64, z = 129.46, phase = 1, adtArea = 1638 },
          } },
        { entry = 3004, name = "Tepa", sub = "Tailoring Trainer", nameDe = "Tepa", subDe = "Schneiderlehrerin", faction = 104, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 26623, map = 1, x = -1165.59, y = 51.94, z = 145.88, phase = 1, adtArea = 1638 },
          } },
        { entry = 3007, name = "Una", sub = "Leatherworking Trainer", nameDe = "Una", subDe = "Lederverarbeitungslehrerin", faction = 104, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 26626, map = 1, x = -1146.21, y = 83.48, z = 145.95, phase = 1, adtArea = 1638 },
          } },
        { entry = 3009, name = "Bena Winterhoof", sub = "Alchemy Trainer", nameDe = "Bena Winterhuf", subDe = "Alchemielehrerin", faction = 104, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 26628, map = 1, x = -1080.81, y = 30.11, z = 140.91, phase = 1, adtArea = 1638 },
          } },
        { entry = 3011, name = "Teg Dawnstrider", sub = "Enchanting Trainer", nameDe = "Teg Morgenwandler", subDe = "Verzauberkunstlehrer", faction = 104, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 26630, map = 1, x = -1110.88, y = 47.9, z = 140.52, phase = 1, adtArea = 1638 },
          } },
        { entry = 3069, name = "Chaw Stronghide", sub = "Leatherworking Trainer", nameDe = "Chaw Starkfell", subDe = "Lederverarbeitungslehrer", faction = 104, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 26909, map = 1, x = -2254.65, y = -286.53, z = -9.34, phase = 1, adtArea = 222 },
          } },
        { entry = 3136, name = "Clarise Gnarltree", sub = "Blacksmithing Trainer", nameDe = "Clarise Knarzbaum", subDe = "Schmiedekunstlehrerin", faction = 12, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 4206, map = 0, x = -10590.5, y = -1164.79, z = 30.13, phase = 1, adtArea = 42 },
          } },
        { entry = 3174, name = "Dwukk", sub = "Blacksmithing Trainer", nameDe = "Dwukk", subDe = "Schmiedekunstlehrer", faction = 29, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 10280, map = 1, x = 373.11, y = -4713.63, z = 15.89, phase = 1, adtArea = 362 },
          } },
        { entry = 3184, name = "Miao'zan", sub = "Alchemy Trainer", nameDe = "Miao'zan", subDe = "Alchemielehrer", faction = 126, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 6396, map = 1, x = -798.27, y = -4892.27, z = 22.98, phase = 1, adtArea = 367 },
          } },
        { entry = 3290, name = "Deek Fizzlebizz", sub = "Engineering Trainer", nameDe = "Deek Zischelblitz", subDe = "Ingenieurslehrer", faction = 875, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 8249, map = 0, x = -4734.76, y = -3260.17, z = 310.34, phase = 1, adtArea = 146 },
          } },
        { entry = 3345, name = "Godan", sub = "Enchanting Trainer", nameDe = "Godan", subDe = "Verzauberkunstlehrer", faction = 29, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 6626, map = 1, x = 1912.18, y = -4436.61, z = 24.88, phase = 1, adtArea = 1637 },
          } },
        { entry = 3347, name = "Yelmak", sub = "Alchemy Trainer", nameDe = "Yelmak", subDe = "Alchemielehrer", faction = 29, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 4681, map = 1, x = 1964.88, y = -4477.84, z = 26.01, phase = 1, adtArea = 1637 },
          } },
        { entry = 3355, name = "Saru Steelfury", sub = "Blacksmithing Trainer", nameDe = "Saru Stahlzorn", subDe = "Schmiedekunstlehrer", faction = 29, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 4670, map = 1, x = 2058.97, y = -4835.58, z = 24.66, phase = 1, adtArea = 1637 },
          } },
        { entry = 3363, name = "Magar", sub = "Tailoring Trainer", nameDe = "Magar", subDe = "Schneiderlehrer", faction = 29, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 6629, map = 1, x = 1806.85, y = -4573.32, z = 23.09, phase = 1, adtArea = 1637 },
          } },
        { entry = 3365, name = "Karolek", sub = "Leatherworking Trainer", nameDe = "Karolek", subDe = "Lederverarbeitungslehrer", faction = 29, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 6630, map = 1, x = 1860.9, y = -4561.51, z = 25.07, phase = 1, adtArea = 1637 },
          } },
        { entry = 3478, name = "Traugh", sub = "Blacksmithing Trainer", nameDe = "Traugh", subDe = "Schmiedekunstlehrer", faction = 29, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 15087, map = 1, x = -340.69, y = -2575.09, z = 97.67, phase = 1, adtArea = 380 },
          } },
        { entry = 3484, name = "Kil'hala", sub = "Tailoring Trainer", nameDe = "Kil'hala", subDe = "Schneiderlehrer", faction = 126, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 15097, map = 1, x = -529.43, y = -2667.07, z = 95.87, phase = 1, adtArea = 380 },
          } },
        { entry = 3494, name = "Tinkerwiz", sub = "Engineering Trainer", nameDe = "T\195\188ftelwiz", subDe = "Ingenieurslehrer", faction = 69, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 15149, map = 1, x = -840.88, y = -3727.2, z = 19.97, phase = 1, adtArea = 392 },
          } },
        { entry = 3523, name = "Bowen Brisboise", sub = "Tailoring Trainer", nameDe = "Bowen Brisboise", subDe = "Schneiderlehrer", faction = 68, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 33818, map = 0, x = 2164.95, y = 656.9, z = 34.63, phase = 1, adtArea = 166 },
          } },
        { entry = 3549, name = "Shelene Rhobart", sub = "Leatherworking Trainer", nameDe = "Shelene Rhobart", subDe = "Lederverarbeitungslehrerin", faction = 68, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 38289, map = 0, x = 2026.28, y = 76.78, z = 35.49, phase = 1, adtArea = 85 },
          } },
        { entry = 3557, name = "Guillaume Sorouy", sub = "Blacksmithing Trainer", nameDe = "Geraldine Sorouy", subDe = "Schmiedekunstlehrerin", faction = 68, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 17625, map = 0, x = 516.32, y = 1635.73, z = 104.71, phase = 1, adtArea = 228 },
          } },
        { entry = 3603, name = "Cyndra Kindwhisper", sub = "Alchemy Trainer", nameDe = "Cyndra Samtwisper", subDe = "Alchemielehrerin", faction = 80, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 46191, map = 1, x = 9767.76, y = 879.81, z = 1297.78, phase = 1, adtArea = 186 },
          } },
        { entry = 3605, name = "Nadyia Maneweaver", sub = "Leatherworking Trainer", nameDe = "Nadyia Schopfweber", subDe = "Lederverarbeitungslehrerin", faction = 80, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 46193, map = 1, x = 10153.3, y = 1682.3, z = 1326.09, phase = 1, adtArea = 141 },
          } },
        { entry = 3606, name = "Alanna Raveneye", sub = "Enchanting Trainer", nameDe = "Alanna Rabenauge", subDe = "Verzauberkunstlehrerin", faction = 80, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 46194, map = 1, x = 10671.9, y = 1945.49, z = 1335.3, phase = 1, adtArea = 264 },
          } },
        { entry = 3703, name = "Krulmoo Fullmoon", sub = "Leatherworking Trainer", nameDe = "Krulmoo Vollmond", subDe = "Lederverarbeitungslehrer", faction = 104, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 14410, map = 1, x = -2404.44, y = -1921.1, z = 96.83, phase = 1, adtArea = 378 },
          } },
        { entry = 3704, name = "Mahani", sub = "Tailoring Trainer", nameDe = "Mahani", subDe = "Schneiderlehrerin", faction = 104, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 14413, map = 1, x = -2400.33, y = -1929.77, z = 96.83, phase = 1, adtArea = 378 },
          } },
        { entry = 3964, name = "Kylanna", sub = "Alchemy Trainer", nameDe = "Kylanna", subDe = "Alchemielehrerin", faction = 80, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 32718, map = 1, x = 2093.31, y = -1232.44, z = 101.88, phase = 1, adtArea = 420 },
          } },
        { entry = 3967, name = "Aayndia Floralwind", sub = "Leatherworking Trainer", nameDe = "Aayndia Bl\195\188tenwind", subDe = "Lederverarbeitungslehrerin", faction = 80, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 32721, map = 1, x = 2670.32, y = -374.73, z = 110.81, phase = 1, adtArea = 415 },
          } },
        { entry = 4159, name = "Me'lynn", sub = "Tailoring Trainer", nameDe = "Me'lynn", subDe = "Schneiderlehrerin", faction = 80, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 46244, map = 1, x = 10080.4, y = 2267.32, z = 1333.08, phase = 1, adtArea = 1659 },
          } },
        { entry = 4160, name = "Ainethil", sub = "Alchemy Trainer", nameDe = "Ainethil", subDe = "Alchemielehrerin", faction = 80, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 46285, map = 1, x = 10068.8, y = 2357.55, z = 1321.66, phase = 1, adtArea = 1659 },
          } },
        { entry = 4193, name = "Grondal Moonbreeze", sub = "Tailoring Trainer", nameDe = "Grondal Mondhauch", subDe = "Schneiderlehrer", faction = 80, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 37081, map = 1, x = 6563.51, y = 436.93, z = 9.14, phase = 1, adtArea = 442 },
          } },
        { entry = 4212, name = "Telonis", sub = "Leatherworking Trainer", nameDe = "Telonis", subDe = "Lederverarbeitungslehrer", faction = 80, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 46466, map = 1, x = 10086.3, y = 2256.49, z = 1343.39, phase = 1, adtArea = 1659 },
          } },
        { entry = 4213, name = "Taladan", sub = "Enchanting Trainer", nameDe = "Taladan", subDe = "Verzauberkunstmeister", faction = 80, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 46467, map = 1, x = 10145.7, y = 2320.28, z = 1333.08, phase = 1, adtArea = 1659 },
          } },
        { entry = 4258, name = "Bengus Deepforge", sub = "Blacksmithing Trainer", nameDe = "Bengus Tiefenschmied", subDe = "Schmiedekunstlehrer", faction = 55, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 2013, map = 0, x = -4787.96, y = -1129.03, z = 498.89, phase = 1, adtArea = 1 },
          } },
        { entry = 4576, name = "Josef Gregorian", sub = "Tailoring Trainer", nameDe = "Josef Gregorian", subDe = "Schneiderlehrer", faction = 68, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 38067, map = 0, x = 1681.49, y = 194.36, z = -62.09, phase = 1, adtArea = 153 },
          } },
        { entry = 4578, name = "Josephine Lister", sub = "Master Shadoweave Tailor", nameDe = "Josephine Lister", subDe = "Schneiderlehrerin", faction = 68, skillLine = 197, rankSpells = {  },
          spawns = {
              { guid = 31868, map = 0, x = 1736.6, y = 41.85, z = -59.23, phase = 1, adtArea = 153 },
          } },
        { entry = 4588, name = "Arthur Moore", sub = "Leatherworking Trainer", nameDe = "Arthur Moor", subDe = "Lederverarbeitungslehrer", faction = 68, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 31884, map = 0, x = 1510.37, y = 199.94, z = -62.05, phase = 1, adtArea = 153 },
          } },
        { entry = 4596, name = "James Van Brunt", sub = "Blacksmithing Trainer", nameDe = "James Van Brunt", subDe = "Schmiedekunstlehrer", faction = 68, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 41843, map = 0, x = 1681.91, y = 285.45, z = -62.05, phase = 1, adtArea = 153 },
          } },
        { entry = 4611, name = "Doctor Herbert Halsey", sub = "Alchemy Trainer", nameDe = "Doktor Herbert Halsey", subDe = "Alchemielehrer", faction = 68, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 38073, map = 0, x = 1408.49, y = 414.87, z = -84.88, phase = 1, adtArea = 153 },
          } },
        { entry = 4616, name = "Lavinia Crowe", sub = "Enchanting Trainer", nameDe = "Lavinia Raab", subDe = "Verzauberkunstlehrerin", faction = 68, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 31879, map = 0, x = 1482.38, y = 273.87, z = -62.08, phase = 1, adtArea = 153 },
          } },
        { entry = 4900, name = "Alchemist Narett", sub = "Alchemy Trainer", nameDe = "Alchemist Narett", subDe = "Alchemielehrer", faction = 894, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 30485, map = 1, x = -3700.84, y = -4331.73, z = 11.5, phase = 1, adtArea = 513 },
          } },
        { entry = 5127, name = "Fimble Finespindle", sub = "Leatherworking Trainer", nameDe = "Fimble Feinspindel", subDe = "Lederverarbeitungslehrer", faction = 875, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 2084, map = 0, x = -4746.93, y = -1031.74, z = 504.52, phase = 1, adtArea = 1 },
          } },
        { entry = 5153, name = "Jormund Stonebrow", sub = "Tailoring Trainer", nameDe = "Jormund Steinbraue", subDe = "Schneiderlehrer", faction = 55, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 1795, map = 0, x = -4724.12, y = -1054.71, z = 504.28, phase = 1, adtArea = 1 },
          } },
        { entry = 5157, name = "Gimble Thistlefuzz", sub = "Enchanting Trainer", nameDe = "Gimble Distelflaum", subDe = "Verzauberkunstlehrer", faction = 875, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 49, map = 0, x = -4809.03, y = -1186.13, z = 512.56, phase = 1, adtArea = 1 },
          } },
        { entry = 5164, name = "Grumnus Steelshaper", sub = "Armorsmith Trainer", nameDe = "Grumnus Scharfstahl", subDe = "Schmiedekunstlehrer", faction = 55, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 2030, map = 0, x = -4795.11, y = -1108.57, z = 498.89, phase = 1, adtArea = 1 },
          } },
        { entry = 5174, name = "Springspindle Fizzlegear", sub = "Engineering Trainer", nameDe = "Sprungspindel Zischelgang", subDe = "Ingenieurslehrer", faction = 55, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 41, map = 0, x = -4798.97, y = -1254.84, z = 502.09, phase = 1, adtArea = 1 },
          } },
        { entry = 5177, name = "Tally Berryfizz", sub = "Alchemy Trainer", nameDe = "Tally Brausefitz", subDe = "Alchemielehrerin", faction = 875, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 29, map = 0, x = -4863.04, y = -1240.3, z = 501.81, phase = 1, adtArea = 1 },
          } },
        { entry = 5499, name = "Lilyssia Nightbreeze", sub = "Alchemy Trainer", nameDe = "Lilyssia Nachtbrise", subDe = "Alchemielehrerin", faction = 12, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 79832, map = 0, x = -8993.05, y = 755.79, z = 98.41, phase = 1, adtArea = 1519 },
          } },
        { entry = 5511, name = "Therum Deepforge", sub = "Blacksmithing Trainer", nameDe = "Therum Tiefenschmied", subDe = "Schmiedekunstlehrer", faction = 12, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 37604, map = 0, x = -8424, y = 616.94, z = 95.54, phase = 1, adtArea = 1519 },
          } },
        { entry = 5518, name = "Lilliam Sparkspindle", sub = "Engineering Trainer", nameDe = "Lilliam Spindelfunks", subDe = "Ingenieurslehrer", faction = 875, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 37611, map = 0, x = -8347, y = 644.13, z = 95.75, phase = 1, adtArea = 1519 },
          } },
        { entry = 5564, name = "Simon Tanner", sub = "Leatherworking Trainer", nameDe = "Simon Gerber", subDe = "Lederverarbeitungslehrer", faction = 12, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 79727, map = 0, x = -8725.55, y = 477.42, z = 98.7, phase = 1, adtArea = 1519 },
          } },
        { entry = 5695, name = "Vance Undergloom", sub = "Enchanting Trainer", nameDe = "Vance Niederglimm", subDe = "Verzauberkunstlehrer", faction = 68, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 33740, map = 0, x = 2284.17, y = 242.13, z = 41.2, phase = 1, adtArea = 159 },
          } },
        { entry = 5784, name = "Waldor", sub = "Leatherworking Trainer", nameDe = "Waldor", subDe = "Lederverarbeitungslehrer", faction = 35, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 15090, map = 1, x = -809.58, y = -2035.4, z = 97.23, phase = 1, adtArea = 17 },
          } },
        { entry = 6299, name = "Delfrum Flintbeard", sub = "Blacksmithing Trainer", nameDe = "Delfrum Zunderbart", subDe = "Schmiedekunstlehrer", faction = 80, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 37954, map = 1, x = 6545.89, y = 440.14, z = 7.65, phase = 1, adtArea = 442 },
          } },
        { entry = 7230, name = "Shayis Steelfury", sub = "Armorsmith Trainer", nameDe = "Shayis Stahlzorn", subDe = "Schmiedekunstlehrerin", faction = 29, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 7463, map = 1, x = 2054.63, y = -4805.99, z = 22.65, phase = 1, adtArea = 1637 },
          } },
        { entry = 7231, name = "Kelgruk Bloodaxe", sub = "Weaponsmith Trainer", nameDe = "Kelgruk Blutaxt", subDe = "Schmiedekunstlehrer", faction = 29, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 6613, map = 1, x = 2105.33, y = -4829.99, z = 24.31, phase = 1, adtArea = 1637 },
          } },
        { entry = 7232, name = "Borgus Steelhand", sub = "Weaponsmith Trainer", nameDe = "Borgus Stahlhand", subDe = "Schmiedekunstlehrer", faction = 55, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 42580, map = 0, x = -8395, y = 688.84, z = 95.27, phase = 1, adtArea = 1519 },
          } },
        { entry = 7406, name = "Oglethorpe Obnoticus", sub = "Gnomish Engineering Trainer", nameDe = "Glotz Widrikus", subDe = "Lehrer f\195\188r gnomische Ingenieurskunst", faction = 120, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 387, map = 0, x = -14417, y = 411.29, z = 22.78, phase = 1, adtArea = 35 },
          } },
        { entry = 7866, name = "Peter Galen", sub = "Dragonscale Leatherworking Trainer", nameDe = "Peter Galen", subDe = "Lederverarbeitungslehrer", faction = 12, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 35885, map = 1, x = 3129.73, y = -5183.02, z = 138.34, phase = 1, adtArea = 1221 },
          } },
        { entry = 7867, name = "Thorkaf Dragoneye", sub = "Dragonscale Leatherworking Trainer", nameDe = "Thorkaf Drachenaug", subDe = "Lederverarbeitungslehrer", faction = 29, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 6931, map = 0, x = -6841.53, y = -3638.87, z = 253.05, phase = 1, adtArea = 3 },
          } },
        { entry = 7868, name = "Sarah Tanner", sub = "Elemental Leatherworking Trainer", nameDe = "Sarah Gerber", subDe = "Lederverarbeitungslehrerin", faction = 12, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 5567, map = 0, x = -7230.06, y = -1741.08, z = 244.53, phase = 1, adtArea = 1958 },
          } },
        { entry = 7869, name = "Brumn Winterhoof", sub = "Elemental Leatherworking Trainer", nameDe = "Brumn Winterhuf", subDe = "Lederverarbeitungslehrer", faction = 104, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 11315, map = 0, x = -1215.47, y = -1884.28, z = 87.62, phase = 1, adtArea = 45 },
          } },
        { entry = 7870, name = "Caryssia Moonhunter", sub = "Tribal Leatherworking Trainer", nameDe = "Caryssia J\195\164germond", subDe = "Lederverarbeitungslehrerin", faction = 80, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 51231, map = 1, x = -4523.55, y = -772.93, z = -40.94, phase = 1, adtArea = 489 },
          } },
        { entry = 7871, name = "Se'Jib", sub = "Tribal Leatherworking Trainer", nameDe = "Se'Jib", subDe = "Lederverarbeitungslehrer", faction = 29, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 540, map = 0, x = -12619, y = -111.23, z = 18.5, phase = 1, adtArea = 33 },
          } },
        { entry = 7944, name = "Tinkmaster Overspark", sub = "Gnomish Engineering Trainer", nameDe = "T\195\188ftlermeister Oberfunks", subDe = "Lehrer f\195\188r gnomische Ingenieurskunst", faction = 64, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 36, map = 0, x = -4834.77, y = -1263.45, z = 501.95, phase = 1, adtArea = 1 },
          } },
        { entry = 7948, name = "Kylanna Windwhisper", sub = "Alchemy Trainer", nameDe = "Kylanna Windraunen", subDe = "Alchemielehrerin", faction = 80, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 50001, map = 1, x = -4395.07, y = 3174.23, z = 17.67, phase = 1, adtArea = 1116 },
          } },
        { entry = 7949, name = "Xylinnia Starshine", sub = "Enchanting Trainer", nameDe = "Xylinnia Sternenschein", subDe = "Verzauberkunstlehrerin", faction = 80, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 50002, map = 1, x = -4416.97, y = 3249.04, z = 12.38, phase = 1, adtArea = 1116 },
          } },
        { entry = 8126, name = "Nixx Sprocketspring", sub = "Goblin Engineering Trainer", nameDe = "Nixx Sprossfeder", subDe = "Lehrer f\195\188r goblinsche Ingenieurskunst", faction = 474, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 23414, map = 1, x = -7131.99, y = -3839.67, z = 9.15, phase = 1, adtArea = 976 },
          } },
        { entry = 8153, name = "Narv Hidecrafter", sub = "Leatherworking Trainer", nameDe = "Narv Flickleder", subDe = "Lederverarbeitungslehrer", faction = 104, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 29133, map = 1, x = -1236.88, y = 1749.59, z = 90.36, phase = 1, adtArea = 597 },
          } },
        { entry = 8736, name = "Buzzek Bracketswing", sub = "Engineering Trainer", nameDe = "Buzzek Pratzenschwing", subDe = "Ingenieurslehrer", faction = 474, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 21820, map = 1, x = -7150.31, y = -3830.19, z = 8.59, phase = 1, adtArea = 976 },
          } },
        { entry = 8738, name = "Vazario Linkgrease", sub = "Goblin Engineering Trainer", nameDe = "Vazario Kuppelschmier", subDe = "Lehrer f\195\188r goblinsche Ingenieurskunst", faction = 69, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 13552, map = 1, x = -836.96, y = -3729.88, z = 19.97, phase = 1, adtArea = 392 },
          } },
        { entry = 9584, name = "Jalane Ayrole", sub = "Master Shadoweave Tailor", nameDe = "Jalane Ayrole", subDe = "Schneiderlehrerin", faction = 12, skillLine = 197, rankSpells = {  },
          spawns = {
              { guid = 90478, map = 0, x = -8976, y = 1021.77, z = 101.49, phase = 1, adtArea = 1519 },
          } },
        { entry = 10993, name = "Twizwick Sprocketgrind", sub = "Engineering Trainer", nameDe = "Twizwick Schraubenschleif", subDe = "Ingenieurslehrer", faction = 69, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 26894, map = 1, x = -1348.7, y = -1129.96, z = 141.8, phase = 1, adtArea = 215 },
          } },
        { entry = 11017, name = "Roxxik", sub = "Engineering Trainer", nameDe = "Roxxik", subDe = "Ingenieurslehrer", faction = 29, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 7969, map = 1, x = 2038.4, y = -4748.98, z = 29.47, phase = 1, adtArea = 1637 },
          } },
        { entry = 11025, name = "Mukdrak", sub = "Engineering Trainer", nameDe = "Mukdrak", subDe = "Ingenieurslehrer", faction = 29, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 7666, map = 1, x = 370.2, y = -4721.57, z = 13.36, phase = 1, adtArea = 362 },
          } },
        { entry = 11031, name = "Franklin Lloyd", sub = "Engineering Trainer", nameDe = "Franklin Lloyd", subDe = "Ingenieurslehrer", faction = 68, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 38103, map = 0, x = 1404.08, y = 142.91, z = -62.22, phase = 1, adtArea = 153 },
          } },
        { entry = 11037, name = "Jenna Lemkenilli", sub = "Engineering Trainer", nameDe = "Jenna Lemkenilli", subDe = "Ingenieurslehrerin", faction = 875, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 36974, map = 1, x = 6537.81, y = 432.83, z = 7.48, phase = 1, adtArea = 442 },
          } },
        { entry = 11052, name = "Timothy Worthington", sub = "Tailoring Trainer", nameDe = "Timothy Wertinger", subDe = "Schneiderlehrer", faction = 894, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 8485, map = 1, x = -3846.73, y = -4449.22, z = 17.33, phase = 1, adtArea = 513 },
          } },
        { entry = 11072, name = "Kitta Firewind", sub = "Enchanting Trainer", nameDe = "Kitta Feuerwind", subDe = "Verzauberkunstlehrerin", faction = 12, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 80933, map = 0, x = -9576.3, y = -718.12, z = 99.27, phase = 1, adtArea = 91 },
          } },
        { entry = 11073, name = "Annora", sub = "Enchanting Trainer", nameDe = "Annora", subDe = "Verzauberkunstlehrerin", faction = 35, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 52882, map = 70, x = -159.8, y = 196.17, z = -49.58, phase = 1, adtArea = 0 },
          } },
        { entry = 11074, name = "Hgarth", sub = "Enchanting Trainer", nameDe = "Hgarth", subDe = "Verzauberkunstlehrer", faction = 29, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 29237, map = 1, x = 1054.63, y = 844.31, z = 165.12, phase = 1, adtArea = 460 },
          } },
        { entry = 11097, name = "Drakk Stonehand", sub = "Leatherworking Trainer", nameDe = "Drakk Steinhand", subDe = "Lederverarbeitungslehrer", faction = 694, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 92948, map = 0, x = 350.42, y = -2090.4, z = 113.87, phase = 1, adtArea = 349 },
          } },
        { entry = 11098, name = "Hahrana Ironhide", sub = "Leatherworking Trainer", nameDe = "Hahrana Eisenhaut", subDe = "Lederverarbeitungslehrerin", faction = 104, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 50142, map = 1, x = -4364.53, y = 273.48, z = 26.4, phase = 1, adtArea = 1099 },
          } },
        { entry = 11146, name = "Ironus Coldsteel", sub = "Weaponsmith Trainer", nameDe = "Ironus Froststahl", subDe = "Schmiedekunstlehrer", faction = 55, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 2029, map = 0, x = -4799.05, y = -1111.48, z = 498.89, phase = 1, adtArea = 1 },
          } },
        { entry = 11177, name = "Okothos Ironrager", sub = "Armorsmith", nameDe = "Okothos Eisenw\195\188ter", subDe = "Schmiedekunstlehrer", faction = 29, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 3429, map = 1, x = 2048.8, y = -4799.86, z = 23.12, phase = 1, adtArea = 1637 },
          } },
        { entry = 11178, name = "Borgosh Corebender", sub = "Weaponsmith", nameDe = "Borgosh Glutformer", subDe = "Schmiedekunstlehrer", faction = 29, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 3430, map = 1, x = 2051.84, y = -4794.39, z = 23.49, phase = 1, adtArea = 1637 },
          } },
        { entry = 11557, name = "Meilosh", sub = "", nameDe = "Meilosh", subDe = "", faction = 414, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 39349, map = 1, x = 7025.63, y = -2135.69, z = 586.41, phase = 1, adtArea = 361 },
          } },
        { entry = 15400, name = "Arathel Sunforge", sub = "Blacksmithing Trainer", nameDe = "Arathel Sonnenschmied", subDe = "Schmiedekunstlehrerin", faction = 1604, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 55356, map = 530, x = 8986.43, y = -7419.07, z = 89.49, phase = 1, adtArea = 3464 },
          } },
        { entry = 15501, name = "Aleinia", sub = "Jewelcrafting Trainer", nameDe = "Aleinia", subDe = "Juwelierskunstlehrerin", faction = 1604, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 } },
          spawns = {
              { guid = 55420, map = 530, x = 9484.79, y = -6876.58, z = 17.5, phase = 1, adtArea = 3665 },
          } },
        { entry = 16160, name = "Magistrix Eredania", sub = "Enchanting Trainer", nameDe = "Magistrix Eredania", subDe = "Verzauberkunstlehrerin", faction = 1604, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 56753, map = 530, x = 8657.6, y = -6366.7, z = 53.59, phase = 1, adtArea = 3468 },
          } },
        { entry = 16161, name = "Arcanist Sheynathren", sub = "Alchemy Trainer", nameDe = "Arkanist Sheynathren", subDe = "Alchemielehrer", faction = 1604, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 56754, map = 530, x = 8661.36, y = -6367, z = 53.63, phase = 1, adtArea = 3468 },
          } },
        { entry = 16278, name = "Sathein", sub = "Leatherworking Trainer", nameDe = "Sathein", subDe = "Lederverarbeitungslehrer", faction = 1604, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 56986, map = 530, x = 9363.75, y = -7130.75, z = 8.68, phase = 1, adtArea = 3430 },
          } },
        { entry = 16366, name = "Sempstress Ambershine", sub = "Tailoring Trainer", nameDe = "N\195\164herin Bernglanz", subDe = "Schneiderlehrerin", faction = 1604, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 57022, map = 530, x = 8680.36, y = -6327.51, z = 56.03, phase = 1, adtArea = 3468 },
          } },
        { entry = 16583, name = "Rohok", sub = "Master Blacksmithing Trainer", nameDe = "Rohok", subDe = "Schmiedekunstlehrer", faction = 1729, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 } },
          spawns = {
              { guid = 57556, map = 530, x = 167.28, y = 2795.67, z = 113.45, phase = 1, adtArea = 3536 },
          } },
        { entry = 16588, name = "Apothecary Antonivich", sub = "Master Alchemy Trainer", nameDe = "Apotheker Antonivich", subDe = "Alchemielehrer", faction = 1729, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 } },
          spawns = {
              { guid = 57561, map = 530, x = 225.66, y = 2839.38, z = 131.42, phase = 1, adtArea = 3536 },
          } },
        { entry = 16633, name = "Sedana", sub = "Enchanting Trainer", nameDe = "Sedana", subDe = "Verzauberkunstlehrerin", faction = 1604, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 57627, map = 530, x = 9962.51, y = -7247.43, z = 32.16, phase = 1, adtArea = 3487 },
          } },
        { entry = 16640, name = "Keelen Sheets", sub = "Tailoring Trainer", nameDe = "Keelen Tuchus", subDe = "Schneiderlehrer", faction = 1604, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 57634, map = 530, x = 9749.56, y = -7095.87, z = 16.77, phase = 1, adtArea = 3487 },
          } },
        { entry = 16642, name = "Camberon", sub = "Alchemy Trainer", nameDe = "Camberon", subDe = "Alchemielehrer", faction = 1604, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 57636, map = 530, x = 10018.3, y = -7209.14, z = 32.16, phase = 1, adtArea = 3487 },
          } },
        { entry = 16667, name = "Danwe", sub = "Engineering Trainer", nameDe = "Danwe", subDe = "Ingenieurslehrerin", faction = 1604, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 57657, map = 530, x = 9822.16, y = -7333.16, z = 26.3, phase = 1, adtArea = 3487 },
          } },
        { entry = 16669, name = "Bemarrin", sub = "Blacksmithing Trainer", nameDe = "Bemarrin", subDe = "Schmiedekunstlehrer", faction = 1604, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 57659, map = 530, x = 9841.98, y = -7362.39, z = 18.59, phase = 1, adtArea = 3487 },
          } },
        { entry = 16688, name = "Lynalis", sub = "Leatherworking Trainer", nameDe = "Lynalis", subDe = "Lederverarbeitungslehrerin", faction = 1604, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 57677, map = 530, x = 9503.61, y = -7430.97, z = 14.23, phase = 1, adtArea = 3487 },
          } },
        { entry = 16723, name = "Lucc", sub = "Alchemy Trainer", nameDe = "Lucc", subDe = "Alchemielehrer", faction = 1638, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 } },
          spawns = {
              { guid = 57710, map = 530, x = -4037.06, y = -11361, z = -138.84, phase = 1, adtArea = 3479 },
          } },
        { entry = 16724, name = "Miall", sub = "Blacksmithing Trainer", nameDe = "Miall", subDe = "Schmiedekunstlehrerin", faction = 1638, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 85595, map = 530, x = -4243.9, y = -11706.7, z = -143.99, phase = 1, adtArea = 3524 },
          } },
        { entry = 16725, name = "Nahogg", sub = "Enchanting Trainer", nameDe = "Nahogg", subDe = "Verzauberkunstlehrer", faction = 1638, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 } },
          spawns = {
              { guid = 85619, map = 530, x = -3882.85, y = -11496.7, z = -136.06, phase = 1, adtArea = 3580 },
          } },
        { entry = 16726, name = "Ockil", sub = "Engineering Trainer", nameDe = "Ockil", subDe = "Ingenieurslehrer", faction = 1638, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 85588, map = 530, x = -4263.95, y = -11638.5, z = -142.01, phase = 1, adtArea = 3524 },
          } },
        { entry = 16728, name = "Akham", sub = "Leatherworking Trainer", nameDe = "Akham", subDe = "Lederverarbeitungslehrer", faction = 1638, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 85597, map = 530, x = -4135.17, y = -11779.7, z = -136.81, phase = 1, adtArea = 3524 },
          } },
        { entry = 16729, name = "Refik", sub = "Tailoring Trainer", nameDe = "Refik", subDe = "Schneiderlehrer", faction = 1638, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 57711, map = 530, x = -4095.78, y = -11747, z = -139.58, phase = 1, adtArea = 3557 },
          } },
        { entry = 16823, name = "Humphry", sub = "Master Blacksmithing Trainer", nameDe = "Humphry", subDe = "Schmiedekunstlehrer", faction = 1671, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 } },
          spawns = {
              { guid = 57881, map = 530, x = -717.32, y = 2607.58, z = 91.01, phase = 1, adtArea = 3538 },
          } },
        { entry = 17215, name = "Daedal", sub = "Alchemy Trainer", nameDe = "Daedal", subDe = "Alchemielehrer", faction = 1638, skillLine = 171, rankSpells = { { 2275, 5 } },
          spawns = {
              { guid = 61739, map = 530, x = -4191.15, y = -12470, z = 45.64, phase = 1, adtArea = 3576 },
          } },
        { entry = 17222, name = "Artificer Daelo", sub = "Engineering Trainer", nameDe = "Konstrukteur Daelo", subDe = "Ingenieurslehrer", faction = 1638, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 } },
          spawns = {
              { guid = 84582, map = 530, x = -4157.57, y = -12470.2, z = 44.98, phase = 1, adtArea = 3576 },
          } },
        { entry = 17245, name = "Blacksmith Calypso", sub = "Blacksmithing Trainer & Supplies", nameDe = "Schmied Calypso", subDe = "Schmiedekunstlehrer & -bedarf", faction = 55, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 61975, map = 530, x = -4726.29, y = -12387, z = 11.17, phase = 1, adtArea = 3573 },
          } },
        { entry = 17442, name = "Moordo", sub = "Leatherworking Trainer", nameDe = "Moordo", subDe = "Lederverarbeitungslehrer", faction = 1685, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 } },
          spawns = {
              { guid = 62917, map = 530, x = -3442.68, y = -12322.2, z = 14.15, phase = 1, adtArea = 3572 },
          } },
        { entry = 17487, name = "Erin Kelly", sub = "Tailoring Trainer", nameDe = "Erin Kelly", subDe = "Schneiderlehrerin", faction = 12, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 } },
          spawns = {
              { guid = 62999, map = 530, x = -4711.54, y = -12386.7, z = 11.94, phase = 1, adtArea = 3573 },
          } },
        { entry = 17634, name = "K. Lee Smallfry", sub = "Master Engineering Trainer", nameDe = "K. Lee Kleinkram", subDe = "Ingenieurskunstlehrerin", faction = 1667, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 } },
          spawns = {
              { guid = 63366, map = 530, x = 252.25, y = 6023.74, z = 131.69, phase = 1, adtArea = 3644 },
          } },
        { entry = 17637, name = "Mack Diver", sub = "Master Engineering Trainer", nameDe = "Mack Dyver", subDe = "Ingenieurskunstlehrer", faction = 1669, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 } },
          spawns = {
              { guid = 63368, map = 530, x = 228.26, y = 7764.29, z = 17.54, phase = 1, adtArea = 3521 },
          } },
        { entry = 18749, name = "Dalinna", sub = "Master Tailoring Trainer", nameDe = "Dalinna", subDe = "Schneiderlehrerin", faction = 1729, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 } },
          spawns = {
              { guid = 67008, map = 530, x = 204.18, y = 2617.73, z = 87.37, phase = 1, adtArea = 3536 },
          } },
        { entry = 18751, name = "Kalaen", sub = "Master Jewelcrafting Trainer", nameDe = "Kalaen", subDe = "Juwelierskunstlehrer", faction = 1729, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 } },
          spawns = {
              { guid = 67024, map = 530, x = 179.75, y = 2607.09, z = 87.37, phase = 1, adtArea = 3536 },
          } },
        { entry = 18752, name = "Zebig", sub = "Master Engineering Trainer", nameDe = "Zebig", subDe = "Ingenieurskunstlehrer", faction = 1729, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 } },
          spawns = {
              { guid = 67025, map = 530, x = 154.99, y = 2710.45, z = 88.16, phase = 1, adtArea = 3536 },
          } },
        { entry = 18753, name = "Felannia", sub = "Master Enchanting Trainer", nameDe = "Felannia", subDe = "Verzauberkunstlehrerin", faction = 1729, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 } },
          spawns = {
              { guid = 67026, map = 530, x = 242.25, y = 2836.55, z = 145.18, phase = 1, adtArea = 3536 },
          } },
        { entry = 18754, name = "Barim Spilthoof", sub = "Master Leatherworking Trainer", nameDe = "Barim Spalthuf", subDe = "Lederverarbeitungslehrer", faction = 29, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 } },
          spawns = {
              { guid = 67027, map = 530, x = 148.59, y = 2636.02, z = 86.02, phase = 1, adtArea = 3536 },
          } },
        { entry = 18771, name = "Brumman", sub = "Master Leatherworking Trainer", nameDe = "Brumman", subDe = "Lederverarbeitungslehrer", faction = 1737, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 } },
          spawns = {
              { guid = 67046, map = 530, x = -721.66, y = 2745.26, z = 94.05, phase = 1, adtArea = 3538 },
          } },
        { entry = 18772, name = "Hama", sub = "Master Tailoring Trainer", nameDe = "Hama", subDe = "Schneiderlehrerin", faction = 1737, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 } },
          spawns = {
              { guid = 67047, map = 530, x = -712.82, y = 2718.37, z = 101.68, phase = 1, adtArea = 3538 },
          } },
        { entry = 18773, name = "Johan Barnes", sub = "Master Enchanting Trainer", nameDe = "Johan Barnes", subDe = "Verzauberkunstlehrer", faction = 1737, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 } },
          spawns = {
              { guid = 67048, map = 530, x = -796.39, y = 2769.96, z = 146.62, phase = 1, adtArea = 3538 },
          } },
        { entry = 18774, name = "Tatiana", sub = "Master Jewelcrafting Trainer", nameDe = "Tatiana", subDe = "Juwelierskunstlehrerin", faction = 1737, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 } },
          spawns = {
              { guid = 67049, map = 530, x = -711.68, y = 2717.99, z = 94.82, phase = 1, adtArea = 3538 },
          } },
        { entry = 18775, name = "Lebowski", sub = "Master Engineering Trainer", nameDe = "Lebowski", subDe = "Ingenieurskunstlehrer", faction = 1737, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 } },
          spawns = {
              { guid = 67050, map = 530, x = -777.6, y = 2661.83, z = 108.25, phase = 1, adtArea = 3538 },
          } },
        { entry = 18802, name = "Alchemist Gribble", sub = "Master Alchemy Trainer", nameDe = "Alchemist Grabbel", subDe = "Alchemielehrer", faction = 1737, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 } },
          spawns = {
              { guid = 67159, map = 530, x = -785.35, y = 2760.92, z = 122.01, phase = 1, adtArea = 3538 },
          } },
        { entry = 19052, name = "Lorokeem", sub = "Master Alchemy Trainer", nameDe = "Lorokeem", subDe = "Alchemielehrer", faction = 1818, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 } },
          spawns = {
              { guid = 68361, map = 530, x = -1661.06, y = 5539.73, z = -4.87, phase = 1, adtArea = 3899 },
          } },
        { entry = 19063, name = "Hamanar", sub = "Master Jewelcrafting Trainer", nameDe = "Hamanar", subDe = "Juwelierskunstlehrer", faction = 1743, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 68364, map = 530, x = -1654.68, y = 5664.69, z = 132.77, phase = 1, adtArea = 3896 },
          } },
        { entry = 19187, name = "Darmari", sub = "Master Leatherworking Trainer", nameDe = "Darmari", subDe = "Lederverarbeitungslehrerin", faction = 1818, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 } },
          spawns = {
              { guid = 68636, map = 530, x = -2060.92, y = 5256.68, z = -38.38, phase = 1, adtArea = 3899 },
          } },
        { entry = 19251, name = "Enchantress Volali", sub = "Enchanting Trainer", nameDe = "Verzauberin Volali", subDe = "Verzauberkunstlehrerin", faction = 1744, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 } },
          spawns = {
              { guid = 68775, map = 530, x = -2277.57, y = 5570.21, z = 79.93, phase = 1, adtArea = 3898 },
          } },
        { entry = 19252, name = "High Enchanter Bardolan", sub = "Master Enchanting Trainer", nameDe = "Meisterverzauberer Bardolan", subDe = "Verzauberkunstlehrer", faction = 1744, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 } },
          spawns = {
              { guid = 68776, map = 530, x = -2278.56, y = 5567.73, z = 79.92, phase = 1, adtArea = 3898 },
          } },
        { entry = 19341, name = "Grutah", sub = "Master Blacksmithing Trainer", nameDe = "Grutah", subDe = "Schmiedekunstlehrer", faction = 1735, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 } },
          spawns = {
              { guid = 68957, map = 530, x = -3103, y = 2595, z = 63, phase = 1, adtArea = 3744 },
          } },
        { entry = 19539, name = "Jazdalaad", sub = "Master Jewelcrafting Trainer", nameDe = "Jazdalaad", subDe = "Juwelierskunstlehrer", faction = 1731, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 } },
          spawns = {
              { guid = 69944, map = 530, x = 4191.23, y = 3001.25, z = 339.39, phase = 1, adtArea = 3738 },
          } },
        { entry = 19540, name = "Asarnan", sub = "Master Enchanting Trainer", nameDe = "Asarnan", subDe = "Verzauberkunstlehrer", faction = 1731, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 } },
          spawns = {
              { guid = 69945, map = 530, x = 4205.09, y = 3017.44, z = 339.39, phase = 1, adtArea = 3738 },
          } },
        { entry = 19576, name = "Xyrol", sub = "Master Engineering Trainer", nameDe = "Xyrol", subDe = "Ingenieurskunstlehrer", faction = 35, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 } },
          spawns = {
              { guid = 70015, map = 530, x = 2974, y = 3672.69, z = 143.63, phase = 1, adtArea = 3712 },
          } },
        { entry = 19775, name = "Kalinda", sub = "Jewelcrafting Trainer", nameDe = "Kalinda", subDe = "Juwelierskunstlehrerin", faction = 1604, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 } },
          spawns = {
              { guid = 70730, map = 530, x = 9558.09, y = -7495.16, z = 16.34, phase = 1, adtArea = 3487 },
          } },
        { entry = 19778, name = "Farii", sub = "Jewelcrafting Trainer", nameDe = "Farii", subDe = "Juwelierskunstlehrerin", faction = 1638, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 } },
          spawns = {
              { guid = 82941, map = 530, x = -3781.55, y = -11541.8, z = -134.74, phase = 1, adtArea = 3580 },
          } },
        { entry = 20124, name = "Kradu Grimblade", sub = "Weaponsmith Trainer", nameDe = "Kradu Grimmklinge", subDe = "Schmiedekunstlehrer", faction = 1818, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 71625, map = 530, x = -1847.61, y = 5230.97, z = -38.05, phase = 1, adtArea = 3703 },
          } },
        { entry = 20125, name = "Zula Slagfury", sub = "Armorsmith Trainer", nameDe = "Zula Schmelzzorn", subDe = "Schmiedekunstlehrerin", faction = 1818, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 71626, map = 530, x = -1839.5, y = 5223.18, z = -37.96, phase = 1, adtArea = 3703 },
          } },
        { entry = 21087, name = "Grikka", sub = "Master Leatherworking Trainer", nameDe = "Grikka", subDe = "Lederverarbeitungslehrerin", faction = 1735, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 } },
          spawns = {
              { guid = 74113, map = 530, x = 2039.82, y = 4675.43, z = 150.07, phase = 1, adtArea = 3844 },
          } },
        { entry = 21209, name = "Dumphry", sub = "Master Blacksmithing Trainer", nameDe = "Dumphry", subDe = "Schmiedekunstlehrer", faction = 1671, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 } },
          spawns = {
              { guid = 74397, map = 530, x = -595.43, y = 2899.24, z = 59.21, phase = 1, adtArea = 3483 },
          } },
        { entry = 21493, name = "Kablamm Farflinger", sub = "Transportation Engineer", nameDe = "Kablamm Weitschleuder", subDe = "Transportingenieur", faction = 35, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 75402, map = 530, x = 3088.5, y = 3645.93, z = 142.64, phase = 1, adtArea = 3712 },
          } },
        { entry = 21494, name = "Smiles O'Byron", sub = "Engineer", nameDe = "Smiles O'Byron", subDe = "Ingenieur", faction = 35, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 75403, map = 530, x = 2050.94, y = 5571.11, z = 262.83, phase = 1, adtArea = 3833 },
          } },
        { entry = 24868, name = "Niobe Whizzlespark", sub = "Master Engineering Trainer", nameDe = "Niobe Funkenritzel", subDe = "Ingenieurskunstlehrerin", faction = 189, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 12717, map = 530, x = -3963.75, y = 2203.92, z = 101.87, phase = 1, adtArea = 3745 },
          } },
        { entry = 25099, name = "Jonathan Garrett", sub = "Master Engineering Trainer", nameDe = "Jonathan Garrett", subDe = "Ingenieurskunstlehrer", faction = 714, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 41791, map = 530, x = -2999.68, y = 2619.98, z = 76.66, phase = 1, adtArea = 3744 },
          } },
        { entry = 25277, name = "Chief Engineer Leveny", sub = "Grand Master Engineer", nameDe = "Chefingenieur Leveny", subDe = "Ingenieurkunstlehrer", faction = 1978, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 }, { 61464, 65 } },
          spawns = {
              { guid = 125569, map = 571, x = 2847.77, y = 6110.22, z = 83.44, phase = 1, adtArea = 4129 },
          } },
        { entry = 26564, name = "Borus Ironbender", sub = "Grand Master Blacksmithing Trainer", nameDe = "Borus Eisenbieger", subDe = "Schmiedekunstlehrer", faction = 1981, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 114374, map = 571, x = 3810.3, y = 1574.13, z = 89.31, phase = 1, adtArea = 4165 },
          } },
        { entry = 26903, name = "Lanolis Dewdrop", sub = "Grand Master Alchemy Trainer", nameDe = "Lanolis Tautropfen", subDe = "Alchemielehrer", faction = 1892, skillLine = 171, rankSpells = { { 51303, 65 } },
          spawns = {
              { guid = 98087, map = 571, x = 608.45, y = -4925.96, z = 17.97, phase = 1, adtArea = 3981 },
          } },
        { entry = 26904, name = "Rosina Rivet", sub = "Grand Master Blacksmithing Trainer", nameDe = "Rosina Kerbstift", subDe = "Schmiedekunstlehrerin", faction = 1892, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 98110, map = 571, x = 545.08, y = -5000.47, z = 10.62, phase = 1, adtArea = 3981 },
          } },
        { entry = 26906, name = "Elizabeth Jackson", sub = "Grand Master Enchanting Trainer", nameDe = "Elizabeth Jackson", subDe = "Verzauberkunstlehrerin", faction = 1892, skillLine = 333, rankSpells = { { 51312, 65 } },
          spawns = {
              { guid = 98236, map = 571, x = 588.05, y = -4940.85, z = 28.18, phase = 1, adtArea = 3981 },
          } },
        { entry = 26907, name = "Tisha Longbridge", sub = "Grand Master Engineering Trainer", nameDe = "Tisha Langbr\195\188ck", subDe = "Ingenieurskunstlehrerin", faction = 1892, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 }, { 61464, 65 } },
          spawns = {
              { guid = 98344, map = 571, x = 534.04, y = -5006.6, z = 10.62, phase = 1, adtArea = 3981 },
          } },
        { entry = 26911, name = "Bernadette Dexter", sub = "Grand Master Leatherworking Trainer", nameDe = "Bernadette Dexter", subDe = "Lederverarbeitungslehrerin", faction = 1892, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 }, { 51301, 65 } },
          spawns = {
              { guid = 98841, map = 571, x = 554.88, y = -5018.89, z = 11.5, phase = 1, adtArea = 3981 },
          } },
        { entry = 26914, name = "Benjamin Clegg", sub = "Grand Master Tailoring Trainer", nameDe = "Benjamin Clegg", subDe = "Schneiderlehrer", faction = 1892, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 }, { 51308, 65 } },
          spawns = {
              { guid = 99018, map = 571, x = 588.85, y = -4938.71, z = 28.17, phase = 1, adtArea = 3981 },
          } },
        { entry = 26915, name = "Ounhulo", sub = "Grand Master Jewelcrafting Trainer", nameDe = "Ounhulo", subDe = "Juwelierskunstlehrer", faction = 1892, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 99181, map = 571, x = 542.82, y = -5020.94, z = 10.69, phase = 1, adtArea = 3981 },
          } },
        { entry = 26916, name = "Mindri Dinkles", sub = "Grand Master Inscription Trainer", nameDe = "Mindri Dinkels", subDe = "Inschriftenkundelehrerin", faction = 1892, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 }, { 45380, 65 } },
          spawns = {
              { guid = 99197, map = 571, x = 599.04, y = -4920.18, z = 29.74, phase = 1, adtArea = 3981 },
          } },
        { entry = 26951, name = "Wilhelmina Renel", sub = "Grand Master Alchemy Trainer", nameDe = "Wilhelmina Renel", subDe = "Alchemielehrerin", faction = 1928, skillLine = 171, rankSpells = { { 51303, 65 } },
          spawns = {
              { guid = 102435, map = 571, x = 1966.66, y = -6159.23, z = 25.21, phase = 1, adtArea = 4000 },
          } },
        { entry = 26952, name = "Kristen Smythe", sub = "Grand Master Blacksmithing Trainer", nameDe = "Kristen Schmydt", subDe = "Schmiedekunstlehrerin", faction = 1928, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 102499, map = 571, x = 1948.67, y = -6191.36, z = 24.05, phase = 1, adtArea = 4000 },
          } },
        { entry = 26954, name = "Emil Autumn", sub = "Grand Master Enchanting Trainer", nameDe = "Emil Herbst", subDe = "Verzauberkunstlehrer", faction = 1928, skillLine = 333, rankSpells = { { 51312, 65 } },
          spawns = {
              { guid = 102605, map = 571, x = 1975.58, y = -6155.45, z = 25.21, phase = 1, adtArea = 4000 },
          } },
        { entry = 26955, name = "Jamesina Watterly", sub = "Grand Master Engineering Trainer", nameDe = "Jamesina Watterly", subDe = "Ingenieurskunstlehrerin", faction = 1928, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 }, { 61464, 65 } },
          spawns = {
              { guid = 102621, map = 571, x = 1904.8, y = -6137.54, z = 18.14, phase = 1, adtArea = 4000 },
          } },
        { entry = 26959, name = "Booker Kells", sub = "Grand Master Inscription Trainer", nameDe = "Buchmacher Kells", subDe = "Inschriftenkundelehrer", faction = 1928, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 }, { 45380, 65 } },
          spawns = {
              { guid = 102850, map = 571, x = 1936.11, y = -6197.33, z = 24.86, phase = 1, adtArea = 4000 },
          } },
        { entry = 26960, name = "Carter Tiffens", sub = "Grand Master Jewelcrafting Trainer", nameDe = "Carter Tiffens", subDe = "Juwelierskunstlehrer", faction = 1928, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 103040, map = 571, x = 1955.86, y = -6196.06, z = 24.09, phase = 1, adtArea = 4000 },
          } },
        { entry = 26961, name = "Gunter Hansen", sub = "Grand Master Leatherworking Trainer", nameDe = "Gunter Hansen", subDe = "Lederverarbeitungslehrer", faction = 1928, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 }, { 51301, 65 } },
          spawns = {
              { guid = 103242, map = 571, x = 1982.36, y = -6131.68, z = 24.49, phase = 1, adtArea = 4000 },
          } },
        { entry = 26964, name = "Alexandra McQueen", sub = "Grand Master Tailoring Trainer", nameDe = "Alexandra McQueen", subDe = "Schneiderlehrerin", faction = 1928, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 }, { 51308, 65 } },
          spawns = {
              { guid = 103364, map = 571, x = 1875.43, y = -6198.47, z = 23.83, phase = 1, adtArea = 4000 },
          } },
        { entry = 26969, name = "Raenah", sub = "Grand Master Tailoring Trainer", nameDe = "Raenah", subDe = "Schneiderlehrerin", faction = 1981, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 }, { 51308, 65 } },
          spawns = {
              { guid = 125423, map = 571, x = 2842.94, y = 6170.93, z = 104.89, phase = 1, adtArea = 4129 },
          } },
        { entry = 26975, name = "Arthur Henslowe", sub = "Grand Master Alchemy Trainer", nameDe = "Arthur Henslow", subDe = "Alchemielehrer", faction = 1981, skillLine = 171, rankSpells = { { 51303, 65 } },
          spawns = {
              { guid = 125426, map = 571, x = 2813.49, y = 6163.41, z = 105.04, phase = 1, adtArea = 4129 },
          } },
        { entry = 26977, name = "Adelene Sunlance", sub = "Grand Master Inscription Trainer", nameDe = "Adelene Sonnenlanze", subDe = "Inschriftenkundelehrerin", faction = 1981, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 }, { 45380, 65 } },
          spawns = {
              { guid = 125428, map = 571, x = 2823.59, y = 6192.59, z = 104.89, phase = 1, adtArea = 4129 },
          } },
        { entry = 26980, name = "Eorain Dawnstrike", sub = "Grand Master Enchanting Trainer", nameDe = "Eorain Morgenschlag", subDe = "Verzauberkunstlehrer", faction = 1981, skillLine = 333, rankSpells = { { 51312, 65 } },
          spawns = {
              { guid = 125429, map = 571, x = 2824.46, y = 6199.23, z = 104.92, phase = 1, adtArea = 4129 },
          } },
        { entry = 26981, name = "Crog Steelspine", sub = "Grand Master Blacksmithing Trainer", nameDe = "Crog Stahlgrat", subDe = "Schmiedekunstlehrer", faction = 1981, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 125430, map = 571, x = 2772.04, y = 6222.61, z = 83.47, phase = 1, adtArea = 4129 },
          } },
        { entry = 26982, name = "Geba'li", sub = "Grand Master Jewelcrafting Trainer", nameDe = "Geba'li", subDe = "Juwelierskunstlehrer", faction = 1981, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 125431, map = 571, x = 2847.77, y = 6170.94, z = 104.92, phase = 1, adtArea = 4129 },
          } },
        { entry = 26987, name = "Falorn Nightwhisper", sub = "Grand Master Alchemy Trainer", nameDe = "Falorn Nachtfl\195\188stern", subDe = "Alchemielehrer", faction = 1892, skillLine = 171, rankSpells = { { 51303, 65 } },
          spawns = {
              { guid = 105533, map = 571, x = 2132.07, y = 5238.43, z = 19.53, phase = 1, adtArea = 4032 },
          } },
        { entry = 26988, name = "Argo Strongstout", sub = "Grand Master Blacksmithing Trainer", nameDe = "Argo Starkbier", subDe = "Schmiedekunstlehrer", faction = 1892, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 105659, map = 571, x = 2338.17, y = 5275.62, z = 7.9, phase = 1, adtArea = 4032 },
          } },
        { entry = 26990, name = "Alexis Marlowe", sub = "Grand Master Enchanting Trainer", nameDe = "Alexis Marlow", subDe = "Verzauberkunstlehrerin", faction = 1892, skillLine = 333, rankSpells = { { 51312, 65 } },
          spawns = {
              { guid = 105993, map = 571, x = 2147.52, y = 5251.18, z = 19.61, phase = 1, adtArea = 4032 },
          } },
        { entry = 26991, name = "Sock Brightbolt", sub = "Grand Master Engineering Trainer", nameDe = "Buchs Hellblitz", subDe = "Ingenieurskunstlehrer", faction = 1892, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 }, { 61464, 65 } },
          spawns = {
              { guid = 106187, map = 571, x = 2121.9, y = 5242.18, z = 19.53, phase = 1, adtArea = 4032 },
          } },
        { entry = 26995, name = "Tink Brightbolt", sub = "Grand Master Inscription Trainer", nameDe = "Klimper Hellblitz", subDe = "Inschriftenkundelehrerin", faction = 1892, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 }, { 45380, 65 } },
          spawns = {
              { guid = 106632, map = 571, x = 2141.77, y = 5252.78, z = 19.56, phase = 1, adtArea = 4032 },
          } },
        { entry = 26996, name = "Awan Iceborn", sub = "Grand Master Leatherworker", nameDe = "Awan Eiskind", subDe = "Lederverarbeitungslehrer", faction = 1922, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 }, { 51301, 65 } },
          spawns = {
              { guid = 106815, map = 571, x = 3478.23, y = 4177.74, z = 17.28, phase = 1, adtArea = 4037 },
          } },
        { entry = 26997, name = "Alestos", sub = "Grand Master Jewelcrafting Trainer", nameDe = "Alestos", subDe = "Juwelierskunstlehrer", faction = 1892, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 106833, map = 571, x = 2120.8, y = 5259.82, z = 19.55, phase = 1, adtArea = 4032 },
          } },
        { entry = 26998, name = "Rosemary Bovard", sub = "Grand Master Leatherworking Trainer", nameDe = "Rosemarie Bovard", subDe = "Lederverarbeitungslehrerin", faction = 1892, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 }, { 51301, 65 } },
          spawns = {
              { guid = 106880, map = 571, x = 2132.72, y = 5255.87, z = 19.53, phase = 1, adtArea = 4032 },
          } },
        { entry = 27001, name = "Darin Goodstitch", sub = "Grand Master Tailoring Trainer", nameDe = "Darin Gutnaht", subDe = "Schneiderlehrer", faction = 1892, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 }, { 51308, 65 } },
          spawns = {
              { guid = 107129, map = 571, x = 2117.3, y = 5261.07, z = 19.53, phase = 1, adtArea = 4032 },
          } },
        { entry = 27023, name = "Apothecary Bressa", sub = "Master Alchemy Trainer", nameDe = "Apothekerin Bressa", subDe = "Alchemielehrerin", faction = 1928, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 } },
          spawns = {
              { guid = 109003, map = 571, x = 3749.03, y = 1596.74, z = 87.11, phase = 1, adtArea = 4165 },
          } },
        { entry = 27029, name = "Apothecary Wormwick", sub = "Master Alchemy Trainer", nameDe = "Apotheker Wurmdocht", subDe = "Alchemielehrer", faction = 1928, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 } },
          spawns = {
              { guid = 109907, map = 571, x = 3252.76, y = -684.58, z = 168.15, phase = 1, adtArea = 4186 },
          } },
        { entry = 27034, name = "Josric Fame", sub = "Grand Master Blacksmithing Trainer", nameDe = "Josric Ruhm", subDe = "Schmiedekunstlehrer", faction = 1928, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 110374, map = 571, x = 3209.26, y = -629.83, z = 160.25, phase = 1, adtArea = 4186 },
          } },
        { entry = 28693, name = "Enchanter Nalthanis", sub = "Grand Master Enchanting Trainer", nameDe = "Verzauberer Nalthanis", subDe = "Verzauberkunstlehrer", faction = 2007, skillLine = 333, rankSpells = { { 51312, 65 } },
          spawns = {
              { guid = 98040, map = 571, x = 5846.42, y = 728.39, z = 642.08, phase = 1, adtArea = 4553 },
          } },
        { entry = 28694, name = "Alard Schmied", sub = "Grand Master Blacksmithing Trainer", nameDe = "Alard Schmied", subDe = "Schmiedekunstlehrer", faction = 2007, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 98070, map = 571, x = 5913.41, y = 676.3, z = 643.58, phase = 1, adtArea = 4553 },
          } },
        { entry = 28697, name = "Timofey Oshenko", sub = "Grand Master Engineering Trainer", nameDe = "Timofey Oshenko", subDe = "Ingenieurskunstlehrer", faction = 2007, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 }, { 61464, 65 } },
          spawns = {
              { guid = 98178, map = 571, x = 5923.3, y = 733.46, z = 642.21, phase = 1, adtArea = 4553 },
          } },
        { entry = 28699, name = "Charles Worth", sub = "Grand Master Tailoring Trainer", nameDe = "Karl Wert", subDe = "Schneiderlehrer", faction = 2007, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 }, { 51308, 65 } },
          spawns = {
              { guid = 98346, map = 571, x = 5881.01, y = 752.59, z = 640.49, phase = 1, adtArea = 4553 },
          } },
        { entry = 28700, name = "Diane Cannings", sub = "Grand Master Leatherworking Trainer", nameDe = "Diana Kanning", subDe = "Lederverarbeitungslehrerin", faction = 2007, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 }, { 51301, 65 } },
          spawns = {
              { guid = 98421, map = 571, x = 5908.16, y = 764.41, z = 641.17, phase = 1, adtArea = 4553 },
          } },
        { entry = 28701, name = "Timothy Jones", sub = "Grand Master Jewelcrafting Trainer", nameDe = "Jonas Timotheus", subDe = "Juwelierskunstlehrer", faction = 2007, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 98589, map = 571, x = 5871.05, y = 714.89, z = 643.18, phase = 1, adtArea = 4553 },
          } },
        { entry = 28702, name = "Professor Pallin", sub = "Grand Master Inscription Trainer", nameDe = "Professor Pallin", subDe = "Inschriftenkundelehrer", faction = 2007, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 }, { 45380, 65 } },
          spawns = {
              { guid = 98803, map = 571, x = 5860.99, y = 707.24, z = 643.35, phase = 1, adtArea = 4553 },
          } },
        { entry = 28703, name = "Linzy Blackbolt", sub = "Grand Master Alchemy Trainer", nameDe = "Linzy Schwarzbolz", subDe = "Alchemielehrerin", faction = 2007, skillLine = 171, rankSpells = { { 51303, 65 } },
          spawns = {
              { guid = 98842, map = 571, x = 5889.27, y = 698.53, z = 643.27, phase = 1, adtArea = 4553 },
          } },
        { entry = 29505, name = "Imindril Spearsong", sub = "Weaponsmithing Trainer", nameDe = "Imindril Speerlied", subDe = "Schmiedekunstlehrer", faction = 2007, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 102048, map = 571, x = 5907.09, y = 675.22, z = 643.5, phase = 1, adtArea = 4553 },
          } },
        { entry = 29506, name = "Orland Schaeffer", sub = "Armorsmithing Trainer", nameDe = "Orland Sch\195\164fer", subDe = "Schmiedekunstlehrer", faction = 2007, skillLine = 164, rankSpells = {  },
          spawns = {
              { guid = 102071, map = 571, x = 5910.86, y = 683.05, z = 643.5, phase = 1, adtArea = 4553 },
          } },
        { entry = 29507, name = "Manfred Staller", sub = "Elemental Leatherworking Trainer", nameDe = "Manfred Staller", subDe = "Lederverarbeitungslehrer", faction = 2007, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 102128, map = 571, x = 5904.79, y = 771.72, z = 649.08, phase = 1, adtArea = 4553 },
          } },
        { entry = 29508, name = "Andellion", sub = "Dragonscale Leatherworking Trainer", nameDe = "Andellion", subDe = "Lederverarbeitungslehrer", faction = 2007, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 102256, map = 571, x = 5918.03, y = 767.9, z = 649.08, phase = 1, adtArea = 4553 },
          } },
        { entry = 29509, name = "Namha Moonwater", sub = "Tribal Leatherworking Trainer", nameDe = "Namha Mondwasser", subDe = "Lederverarbeitungslehrerin", faction = 2007, skillLine = 165, rankSpells = {  },
          spawns = {
              { guid = 102354, map = 571, x = 5899.16, y = 753.09, z = 652.78, phase = 1, adtArea = 4553 },
          } },
        { entry = 29513, name = "Didi the Wrench", sub = "Goblin Engineering Trainer", nameDe = "Didi Biegezange", subDe = "Gobliningenieurslehrerin", faction = 2007, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 102530, map = 571, x = 5927.85, y = 723.43, z = 642.22, phase = 1, adtArea = 4553 },
          } },
        { entry = 29514, name = "Findle Whistlesteam", sub = "Gnome Engineering Trainer", nameDe = "Findel Pfeifendampf", subDe = "Gnomischer Ingenieurslehrer", faction = 2007, skillLine = 202, rankSpells = {  },
          spawns = {
              { guid = 102606, map = 571, x = 5929.62, y = 724.73, z = 642.21, phase = 1, adtArea = 4553 },
          } },
        { entry = 29924, name = "Brandig", sub = "Grand Master Blacksmithing Trainer", nameDe = "Brandig", subDe = "Schmiedekunstlehrer", faction = 1733, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 117740, map = 571, x = 6643.61, y = -210.4, z = 951.85, phase = 1, adtArea = 4428 },
          } },
        { entry = 30706, name = "Jo'mah", sub = "Inscription Trainer", nameDe = "Jo'mah", subDe = "Inschriftenkundelehrer", faction = 126, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 34033, map = 1, x = 1839.02, y = -4465.98, z = 47.71, phase = 1, adtArea = 1637 },
          } },
        { entry = 30709, name = "Poshken Hardbinder", sub = "Inscription Trainer", nameDe = "Poshken R\195\188ckenbinder", subDe = "Inschriftenkundelehrer", faction = 68, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 125643, map = 1, x = -999, y = 208.72, z = 106.48, phase = 1, adtArea = 1640 },
          } },
        { entry = 30710, name = "Zantasia", sub = "Inscription Trainer", nameDe = "Zantasia", subDe = "Inschriftenkundelehrerin", faction = 1604, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 125645, map = 530, x = 9958.94, y = -7250.08, z = 32.08, phase = 1, adtArea = 3487 },
          } },
        { entry = 30711, name = "Margaux Parchley", sub = "Inscription Trainer", nameDe = "Margaux Pergament", subDe = "Inschriftenkundelehrerin", faction = 68, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 125644, map = 0, x = 1507.76, y = 283.65, z = -62.17, phase = 1, adtArea = 153 },
          } },
        { entry = 30713, name = "Catarina Stanford", sub = "Inscription Trainer", nameDe = "Catarina Stanford", subDe = "Inschriftenkundelehrerin", faction = 12, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 120826, map = 0, x = -8862.5, y = 857.2, z = 99.69, phase = 1, adtArea = 1519 },
          } },
        { entry = 30715, name = "Feyden Darkin", sub = "Inscription Trainer", nameDe = "Feyden Tintenrot", subDe = "Inschriftenkundelehrer", faction = 80, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 125647, map = 1, x = 10139.7, y = 2313, z = 1343.39, phase = 1, adtArea = 1659 },
          } },
        { entry = 30716, name = "Thoth", sub = "Inscription Trainer", nameDe = "Thoth", subDe = "Inschriftenkundelehrer", faction = 1638, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 125648, map = 530, x = -3890.05, y = -11494.8, z = -136.22, phase = 1, adtArea = 3580 },
          } },
        { entry = 30717, name = "Elise Brightletter", sub = "Inscription Trainer", nameDe = "Elise Majuskel", subDe = "Inschriftenkundelehrerin", faction = 55, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 } },
          spawns = {
              { guid = 125646, map = 0, x = -4807.46, y = -1196.28, z = 505.82, phase = 1, adtArea = 1 },
          } },
        { entry = 30721, name = "Michael Schwan", sub = "Master Inscription Trainer", nameDe = "Michael Schwan", subDe = "Inschriftenkundelehrer", faction = 1737, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 } },
          spawns = {
              { guid = 10497, map = 530, x = -773.81, y = 2751.21, z = 146.54, phase = 1, adtArea = 3538 },
          } },
        { entry = 30722, name = "Neferatti", sub = "Master Inscription Trainer", nameDe = "Neferatti", subDe = "Inschriftenkundelehrerin", faction = 1729, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 } },
          spawns = {
              { guid = 34034, map = 530, x = 238.4, y = 2840.97, z = 145.09, phase = 1, adtArea = 3536 },
          } },
        { entry = 33580, name = "Dustin Vail", sub = "Grand Master Tailoring Trainer", nameDe = "Dustin Schlaier", subDe = "Schneiderlehrer", faction = 2070, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 }, { 51308, 65 } },
          spawns = {
              { guid = 74480, map = 571, x = 8553.96, y = 863.63, z = 547.44, phase = 1, adtArea = 4658 },
          } },
        { entry = 33581, name = "Kul'de", sub = "Grand Master Leatherworking Trainer", nameDe = "Kul'de", subDe = "Lederverarbeitungslehrer", faction = 2070, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 }, { 51301, 65 } },
          spawns = {
              { guid = 74701, map = 571, x = 8556.13, y = 942.08, z = 547.66, phase = 1, adtArea = 4658 },
          } },
        { entry = 33583, name = "Fael Morningsong", sub = "Grand Master Enchanting Trainer", nameDe = "Fael Morgensang", subDe = "Verzauberkunstlehrer", faction = 2070, skillLine = 333, rankSpells = { { 51312, 65 } },
          spawns = {
              { guid = 74975, map = 571, x = 8569.21, y = 863.48, z = 547.65, phase = 1, adtArea = 4658 },
          } },
        { entry = 33586, name = "Binkie Brightgear", sub = "Grand Master Engineering Trainer", nameDe = "Binkie Klargang", subDe = "Ingenieurskunstlehrerin", faction = 2070, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 }, { 61464, 65 } },
          spawns = {
              { guid = 75471, map = 571, x = 8551.09, y = 917.83, z = 547.38, phase = 1, adtArea = 4658 },
          } },
        { entry = 33588, name = "Crystal Brightspark", sub = "Grand Master Alchemy Trainer", nameDe = "Krista Hellfunk", subDe = "Alchemielehrerin", faction = 2070, skillLine = 171, rankSpells = { { 51303, 65 } },
          spawns = {
              { guid = 75903, map = 571, x = 8546.45, y = 953.05, z = 547.38, phase = 1, adtArea = 4658 },
          } },
        { entry = 33590, name = "Oluros", sub = "Grand Master Jewelcrafting Trainer", nameDe = "Oluros", subDe = "Juwelierskunstlehrer", faction = 2070, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 75906, map = 571, x = 8553.32, y = 962.42, z = 547.56, phase = 1, adtArea = 4658 },
          } },
        { entry = 33591, name = "Rekka the Hammer", sub = "Grand Master Blacksmithing Trainer", nameDe = "Rekka die Hammerfrau", subDe = "Schmiedekunstlehrerin", faction = 2070, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 75910, map = 571, x = 8550.03, y = 936.91, z = 547.38, phase = 1, adtArea = 4658 },
          } },
        { entry = 33603, name = "Arthur Denny", sub = "Grand Master Inscription Trainer", nameDe = "Arthur Denny", subDe = "Inschriftenkundelehrer", faction = 2070, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 }, { 45380, 65 } },
          spawns = {
              { guid = 120606, map = 571, x = 8549.54, y = 944.76, z = 547.37, phase = 1, adtArea = 4658 },
          } },
        { entry = 33608, name = "Alchemy", sub = "", nameDe = "Alchemie", subDe = "", faction = 1744, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 }, { 51303, 65 } },
          spawns = {
              { guid = 40266, map = 530, x = -2263.63, y = 5559.49, z = 67.09, phase = 1, adtArea = 3898 },
          } },
        { entry = 33609, name = "Blacksmithing", sub = "", nameDe = "Schmiedekunst", subDe = "", faction = 1744, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 }, { 51298, 60 } },
          spawns = {
              { guid = 40510, map = 530, x = -2262.64, y = 5561.96, z = 67.09, phase = 1, adtArea = 3898 },
          } },
        { entry = 33610, name = "Enchanting", sub = "", nameDe = "Verzauberkunst", subDe = "", faction = 1744, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 }, { 51312, 65 } },
          spawns = {
              { guid = 40516, map = 530, x = -2261.59, y = 5564.54, z = 67.1, phase = 1, adtArea = 3898 },
          } },
        { entry = 33611, name = "Engineering", sub = "", nameDe = "Ingenieurskunst", subDe = "", faction = 1744, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 }, { 61464, 65 } },
          spawns = {
              { guid = 40517, map = 530, x = -2260.64, y = 5567.08, z = 67.09, phase = 1, adtArea = 3898 },
          } },
        { entry = 33612, name = "Leatherworking", sub = "", nameDe = "Lederverarbeitung", subDe = "", faction = 1744, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 }, { 51301, 65 } },
          spawns = {
              { guid = 40518, map = 530, x = -2264.54, y = 5562.77, z = 67.09, phase = 1, adtArea = 3898 },
          } },
        { entry = 33613, name = "Tailoring", sub = "", nameDe = "Schneidern", subDe = "", faction = 1744, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 }, { 51308, 65 } },
          spawns = {
              { guid = 40601, map = 530, x = -2265.57, y = 5560.32, z = 67.09, phase = 1, adtArea = 3898 },
          } },
        { entry = 33614, name = "Jewelcrafting", sub = "", nameDe = "Juwelierskunst", subDe = "", faction = 1744, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 }, { 51310, 60 } },
          spawns = {
              { guid = 40602, map = 530, x = -2263.47, y = 5565.35, z = 67.09, phase = 1, adtArea = 3898 },
          } },
        { entry = 33615, name = "Inscription", sub = "", nameDe = "Inschriftenkunde", subDe = "", faction = 1744, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 }, { 45380, 65 } },
          spawns = {
              { guid = 40603, map = 530, x = -2262.36, y = 5567.8, z = 67.09, phase = 1, adtArea = 3898 },
          } },
        { entry = 33630, name = "Aelthin", sub = "Master Alchemy Trainer", nameDe = "Aelthin", subDe = "Alchemielehrer", faction = 1744, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 } },
          spawns = {
              { guid = 75088, map = 530, x = -2091.98, y = 5634.98, z = 50.31, phase = 1, adtArea = 3898 },
          } },
        { entry = 33631, name = "Barien", sub = "Master Blacksmithing Trainer", nameDe = "Barien", subDe = "Schmiedekunstlehrer", faction = 1744, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 } },
          spawns = {
              { guid = 88269, map = 530, x = -2040.66, y = 5567.97, z = 53.38, phase = 1, adtArea = 3898 },
          } },
        { entry = 33633, name = "Enchantress Andiala", sub = "Master Enchanting Trainer", nameDe = "Verzauberin Andiala", subDe = "Verzauberkunstlehrerin", faction = 1744, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 } },
          spawns = {
              { guid = 88268, map = 530, x = -2124.96, y = 5410.95, z = 54.86, phase = 1, adtArea = 3898 },
          } },
        { entry = 33634, name = "Engineer Sinbei", sub = "Master Engineering Trainer", nameDe = "Ingenieur Sinbei", subDe = "Ingenieurskunstlehrerin", faction = 1744, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 } },
          spawns = {
              { guid = 88270, map = 530, x = -2041.29, y = 5561.97, z = 54.44, phase = 1, adtArea = 3898 },
          } },
        { entry = 33635, name = "Daenril", sub = "Master Leatherworking Trainer", nameDe = "Daenril", subDe = "Lederverarbeitungslehrer", faction = 1744, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 } },
          spawns = {
              { guid = 88271, map = 530, x = -2023.51, y = 5596.42, z = 53.38, phase = 1, adtArea = 3898 },
          } },
        { entry = 33636, name = "Miralisse", sub = "Master Tailoring Trainer", nameDe = "Miralisse", subDe = "Schneiderlehrerin", faction = 1744, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 } },
          spawns = {
              { guid = 88272, map = 530, x = -2026.79, y = 5598.05, z = 53.38, phase = 1, adtArea = 3898 },
          } },
        { entry = 33637, name = "Kirembri Silvermane", sub = "Master Jewelcrafting Trainer", nameDe = "Kirembri Silberm\195\164hne", subDe = "Juwelierskunstlehrer", faction = 1744, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 } },
          spawns = {
              { guid = 88267, map = 530, x = -2128.67, y = 5372.53, z = 53.81, phase = 1, adtArea = 3703 },
          } },
        { entry = 33638, name = "Scribe Lanloer", sub = "Master Inscription Trainer", nameDe = "Schreiber Lanloer", subDe = "Inschriftenkundelehrer", faction = 1744, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 } },
          spawns = {
              { guid = 47642, map = 530, x = -2121.53, y = 5405.8, z = 53.81, phase = 1, adtArea = 3898 },
          } },
        { entry = 33674, name = "Alchemist Kanhu", sub = "Master Alchemy Trainer", nameDe = "Alchemist Kanhu", subDe = "Alchemielehrer", faction = 1743, skillLine = 171, rankSpells = { { 2275, 5 }, { 2280, 10 }, { 3465, 20 }, { 11612, 35 }, { 28597, 50 } },
          spawns = {
              { guid = 88259, map = 530, x = -1737.53, y = 5629.11, z = 128.02, phase = 1, adtArea = 3896 },
          } },
        { entry = 33675, name = "Onodo", sub = "Master Blacksmithing Trainer", nameDe = "Onodo", subDe = "Schmiedekunstlehrer", faction = 1743, skillLine = 164, rankSpells = { { 2020, 5 }, { 2021, 10 }, { 3539, 20 }, { 9786, 35 }, { 29845, 50 } },
          spawns = {
              { guid = 88261, map = 530, x = -1747.66, y = 5643.65, z = 128.02, phase = 1, adtArea = 3896 },
          } },
        { entry = 33676, name = "Zurii", sub = "Master Enchanting Trainer", nameDe = "Zurii", subDe = "Verzauberkunstlehrerin", faction = 1743, skillLine = 333, rankSpells = { { 7414, 5 }, { 7415, 10 }, { 7416, 20 }, { 13921, 35 }, { 28030, 50 } },
          spawns = {
              { guid = 88255, map = 530, x = -1858.61, y = 5658.11, z = 127.46, phase = 1, adtArea = 3896 },
          } },
        { entry = 33677, name = "Technician Mihila", sub = "Master Engineering Trainer", nameDe = "Technikerin Mihila", subDe = "Ingenieurskunstlehrerin", faction = 1743, skillLine = 202, rankSpells = { { 4039, 5 }, { 4040, 10 }, { 4041, 20 }, { 12657, 35 }, { 30351, 50 } },
          spawns = {
              { guid = 88262, map = 530, x = -1751.24, y = 5641.23, z = 129.07, phase = 1, adtArea = 3896 },
          } },
        { entry = 33679, name = "Recorder Lidio", sub = "Master Inscription Trainer", nameDe = "Registrator Lidio", subDe = "Inschriftenkundelehrer", faction = 1743, skillLine = 773, rankSpells = { { 45375, 5 }, { 45376, 10 }, { 45377, 20 }, { 45378, 35 }, { 45379, 50 } },
          spawns = {
              { guid = 47646, map = 530, x = -1853.15, y = 5663.53, z = 128.52, phase = 1, adtArea = 3896 },
          } },
        { entry = 33680, name = "Nemiha", sub = "Master Jewelcrafting Trainer", nameDe = "Nemiha", subDe = "Juwelierskunstlehrerin", faction = 1743, skillLine = 755, rankSpells = { { 25245, 5 }, { 25246, 10 }, { 28896, 20 }, { 28899, 35 }, { 28901, 50 } },
          spawns = {
              { guid = 88256, map = 530, x = -1892.28, y = 5662.67, z = 127.46, phase = 1, adtArea = 3896 },
          } },
        { entry = 33681, name = "Korim", sub = "Master Leatherworking Trainer", nameDe = "Korim", subDe = "Lederverarbeitungslehrer", faction = 1743, skillLine = 165, rankSpells = { { 2154, 10 }, { 2155, 5 }, { 3812, 20 }, { 10663, 35 }, { 32550, 50 } },
          spawns = {
              { guid = 88265, map = 530, x = -1712.55, y = 5646.23, z = 128.02, phase = 1, adtArea = 3896 },
          } },
        { entry = 33684, name = "Weaver Aoa", sub = "Master Tailoring Trainer", nameDe = "Weberin Aoa", subDe = "Schneiderlehrerin", faction = 1743, skillLine = 197, rankSpells = { { 3911, 5 }, { 3912, 10 }, { 3913, 20 }, { 12181, 35 }, { 26791, 50 } },
          spawns = {
              { guid = 88264, map = 530, x = -1708.82, y = 5642.69, z = 129.07, phase = 1, adtArea = 3896 },
          } },
    },
}
