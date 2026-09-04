-- Tests for PP.util link parsers (pure string handling).

local util = _G.ProfessionPilot.util

-- 3.3.5 trade skill recipe links use the enchant: form.
T.eq(util.SpellIdFromRecipeLink("|cffffd000|Henchant:3923|h[Raue Kupferbombe]|h|r"),
    3923, "recipe link -> spell id")
T.eq(util.SpellIdFromRecipeLink("|Henchant:56477|h[x]|h"), 56477,
    "bare enchant link")
T.eq(util.SpellIdFromRecipeLink(nil), nil, "nil recipe link")
T.eq(util.SpellIdFromRecipeLink(""), nil, "empty recipe link")
T.eq(util.SpellIdFromRecipeLink("|Hitem:2840|h[x]|h"), nil,
    "item link is not a recipe link")

-- Full 3.3.5 item link format (9 colon fields).
T.eq(util.ItemIdFromLink(
    "|cffffffff|Hitem:2840:0:0:0:0:0:0:0:80|h[Kupferbarren]|h|r"),
    2840, "full item link -> item id")
T.eq(util.ItemIdFromLink("|Hitem:36913:0:0:0:0:0:0:0|h[Saronitbarren]|h"),
    36913, "short item link")
T.eq(util.ItemIdFromLink(nil), nil, "nil item link")
T.eq(util.ItemIdFromLink("garbage"), nil, "garbage item link")
T.eq(util.ItemIdFromLink("|Henchant:3923|h[x]|h"), nil,
    "recipe link is not an item link")

-- FormatMoney (used by the auction price integration).
T.eq(util.FormatMoney(0), "0c", "zero copper")
T.eq(util.FormatMoney(56), "56c", "copper only")
T.eq(util.FormatMoney(3456), "34s 56c", "silver and copper")
T.eq(util.FormatMoney(123456), "12g 34s 56c", "gold silver copper")
T.eq(util.FormatMoney(120000), "12g", "zero units omitted")
T.eq(util.FormatMoney(10000), "1g", "exact gold")
T.eq(util.FormatMoney(99.6), "1s", "rounded to nearest copper")
T.eq(util.FormatMoney(nil), nil, "nil passthrough")
T.eq(util.FormatMoney(-5), "0c", "negative clamped")
