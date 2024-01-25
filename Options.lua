local addonName, addon = ...
local RB = RetailBags

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local optionsTable = {
    type = "group",
    args = {
        BagSettings = {
            type = "group",
            inline = true,
            name = "Bag Settings",
            width = "full",
            args = {
                DisplayBagsAutomatically = {
                    type = "toggle",
                    order = 1,
                    name = "Open all bags automatically when character pane shows up",
                    desc = "Automatically toggles all bags when character pane visibility changes.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayBagsWithCharacterPane end,
                    set = function(info, value)
                        RB.DB.profile.displayBagsWithCharacterPane = value
                    end,
                },
                DisplaySearch = {
                    type = "toggle",
                    order = 2,
                    name = "Display search box",
                    desc = "Display a search box to filter your bags.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displaySearchBox end,
                    set = function(info, value)
                        RB.DB.profile.displaySearchBox = value;
                        if (value) then
                            RB.BagItemSearchBox:Show();
                        else
                            RB.BagItemSearchBox:Hide();
                        end
                    end,
                },
                DisplaySortButton = {
                    type = "toggle",
                    order = 3,
                    name = "Display sort button",
                    desc = "Display a sort button to arrange your bags.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displaySortButton end,
                    set = function(info, value)
                        RB.DB.profile.displaySortButton = value;
                        if (value) then
                            RB.BagItemAutoSortButton:Show();
                        else
                            RB.BagItemAutoSortButton:Hide();
                        end
                    end,
                },
                SortBagsRightToLeft = {
                    type = "toggle",
                    order = 4,
                    name = "Sort bags right to left",
                    desc = "Changes sorting direction.",
                    width = "full",
                    get = function(info) return RB.DB.profile.sortBagsRightToLeft end,
                    set = function(info, value)
                        RB.DB.profile.sortBagsRightToLeft = value;
                        SetSortBagsRightToLeft(value);
                    end,
                },
                DisplayItemBorders = {
                    type = "toggle",
                    order = 5,
                    name = "Display item borders",
                    desc = "Adds colored borders with item quality colors.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayItemQualityBorders end,
                    set = function(info, value)
                        RB.DB.profile.displayItemQualityBorders = value;
                    end,
                },
                ContainerScale = {
                    type = "range",
                    order = 6,
                    name = "Bags container scale",
                    desc = "Change size of bag containers.",
                    min = 1,
                    max = 2,
                    step = .1,
                    get = function(info) return RB.DB.profile.bagContainerScale end,
                    set = function(info, value)
                        RB.DB.profile.bagContainerScale = value;
                        CONTAINER_SCALE = RB.DB.profile.bagContainerScale;
                    end,
                }
            },
        }, TooltipSettings = {
            type = "group",
            inline = true,
            name = "Tooltip Settings",
            width = "full",
            args = {
                DisplayItemQuality = {
                    type = "toggle",
                    order = 1,
                    name = "Display item quality",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayTooltipItemQuality end,
                    set = function(info, value)
                        RB.DB.profile.displayTooltipItemQuality = value
                    end,
                },
                DisplayItemLevel = {
                    type = "toggle",
                    order = 1,
                    name = "Display item level",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayTooltipItemLevel end,
                    set = function(info, value)
                        RB.DB.profile.displayTooltipItemLevel = value
                    end,
                },
                DisplayCraftingReagent = {
                    type = "toggle",
                    order = 1,
                    name = "Display crafting reagent",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayTooltipCraftingReagent end,
                    set = function(info, value)
                        RB.DB.profile.displayTooltipCraftingReagent = value
                    end,
                },
                DisplayVendorPrice = {
                    type = "toggle",
                    order = 1,
                    name = "Display vendor price",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayTooltipVendorPrice end,
                    set = function(info, value)
                        RB.DB.profile.displayTooltipVendorPrice = value
                    end,
                }
            },
        }
    }
  }

AceConfig:RegisterOptionsTable(addonName, optionsTable, nil);
AceConfigDialog:AddToBlizOptions(addonName);
