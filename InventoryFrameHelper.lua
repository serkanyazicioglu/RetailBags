local RB = RetailBags

local ItemSlots = {
    { "AMMOSLOT",          "Ammo",      0,  INVSLOT_AMMO,     "AmmoSlot" },
    { "HEADSLOT",          "Head",      1,  INVSLOT_HEAD,     "HeadSlot" },
    { "NECKSLOT",          "Neck",      2,  INVSLOT_NECK,     "NeckSlot" },
    { "SHOULDERSLOT",      "Shoulders", 3,  INVSLOT_SHOULDER, "ShoulderSlot" },
    { "SHIRTSLOT",         "Shirt",     4,  INVSLOT_BODY,     "ShirtSlot" },
    { "CHESTSLOT",         "Chest",     5,  INVSLOT_CHEST,    "ChestSlot" },
    { "WAISTSLOT",         "Waist",     6,  INVSLOT_WAIST,    "WaistSlot" },
    { "LEGSSLOT",          "Legs",      7,  INVSLOT_LEGS,     "LegsSlot" },
    { "FEETSLOT",          "Feet",      8,  INVSLOT_FEET,     "FeetSlot" },
    { "WRISTSLOT",         "Wrist",     9,  INVSLOT_WRIST,    "WristSlot" },
    { "HANDSSLOT",         "Hands",     10, INVSLOT_HAND,     "HandsSlot" },
    { "FINGER0SLOT",       "Finger",    11, INVSLOT_FINGER1,  "Finger0Slot" },
    { "FINGER1SLOT",       "Finger",    12, INVSLOT_FINGER2,  "Finger1Slot" },
    { "TRINKET0SLOT",      "Trinket",   13, INVSLOT_TRINKET1, "Trinket0Slot" },
    { "TRINKET1SLOT",      "Trinket",   14, INVSLOT_TRINKET2, "Trinket1Slot" },
    { "BACKSLOT",          "Back",      15, INVSLOT_BACK,     "BackSlot" },
    { "MAINHANDSLOT",      "Main Hand", 16, INVSLOT_MAINHAND, "MainHandSlot" },
    { "SECONDARYHANDSLOT", "Off Hand",  17, INVSLOT_OFFHAND,  "SecondaryHandSlot" },
    { "RANGEDSLOT",        "Ranged",    18, INVSLOT_RANGED,   "RangedSlot" },
    { "TABARDSLOT",        "Tabard",    19, INVSLOT_TABARD,   "TabardSlot" }
}

function RB:InitInventory(frame)
    if (frame:IsShown()) then
        RB:InitTargetInventory("player", "Character");
    end
end

function RB:InitInspectInventory()
    RB:InitTargetInventory("target", "Inspect");
end

function RB:InitTargetInventory(targetName, slotIdentifier)
    for index, iterElementData in ipairs(ItemSlots) do
        local frame = _G[slotIdentifier .. iterElementData[5]]

        if (frame) then
            if (not RB.DB.profile.displayItemQualityBorders) then
                if (frame.RetailBagsBorder) then
                    frame.RetailBagsBorder:Hide();
                end
            else
                local itemQuality = GetInventoryItemQuality(targetName, iterElementData[3]);

                if (itemQuality) then
                    if itemQuality and itemQuality ~= Enum.ItemQuality.Poor then
                        local size = nil;
                        if iterElementData[4] == INVSLOT_AMMO then
                            size = 38;
                        end

                        CreateBorder(frame, itemQuality, Enum.ItemClass.Armor, size);
                    end
                elseif (frame.RetailBagsBorder) then
                    frame.RetailBagsBorder:Hide();
                end
            end
        end
    end
end
