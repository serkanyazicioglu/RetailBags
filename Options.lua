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
                DisplaySearch = {
                    type = "toggle",
                    order = 1,
                    name = "Display search box",
                    desc = "Display search boxes to filter your bags and bank.",
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
                    order = 2,
                    name = "Display sort button",
                    desc = "Display ort buttons to arrange your bags and bank.",
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
                    order = 3,
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
                    order = 4,
                    name = "Display item borders",
                    desc = "Adds colored borders with item quality colors.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayItemQualityBorders end,
                    set = function(info, value)
                        RB.DB.profile.displayItemQualityBorders = value;
                    end,
                },
                MakeReagentBorderBlue = {
                    type = "toggle",
                    order = 5,
                    name = "Show reagent borders as blue colored",
                    desc = "Instead of item quality color show all reagents with blue border.",
                    width = "full",
                    get = function(info) return RB.DB.profile.makeReagentBordersBlue end,
                    set = function(info, value)
                        RB.DB.profile.makeReagentBordersBlue = value;
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
                },
                DisplayBagsAutomaticallyWithCharacterPane = {
                    type = "toggle",
                    order = 7,
                    name = "Open all bags automatically when character pane shows up",
                    desc = "Automatically toggles all bags when character pane visibility changes.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayBagsWithCharacterPane end,
                    set = function(info, value)
                        RB.DB.profile.displayBagsWithCharacterPane = value
                    end,
                },
                DisplayBagsAutomaticallyWithAuctionHouse = {
                    type = "toggle",
                    order = 8,
                    name = "Open all bags automatically when auction house shows up",
                    desc = "Automatically toggles all bags when auction house visibility changes.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayBagsWithAuctionPane end,
                    set = function(info, value)
                        RB.DB.profile.displayBagsWithAuctionPane = value
                    end,
                },
                DisplayKeyringAutomaticallyWithCharacterPane = {
                    type = "toggle",
                    order = 9,
                    name = "Open keyring automatically when character pane shows up",
                    desc = "Automatically toggles keyring when character pane visibility changes.",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayKeyringWithCharacterPane end,
                    set = function(info, value)
                        RB.DB.profile.displayKeyringWithCharacterPane = value
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
                    order = 2,
                    name = "Display item level",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayTooltipItemLevel end,
                    set = function(info, value)
                        RB.DB.profile.displayTooltipItemLevel = value
                    end,
                },
                DisplayCraftingReagent = {
                    type = "toggle",
                    order = 3,
                    name = "Display crafting reagent label",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayTooltipCraftingReagent end,
                    set = function(info, value)
                        RB.DB.profile.displayTooltipCraftingReagent = value
                    end,
                },
                DisplayMaxStackSize = {
                    type = "toggle",
                    order = 4,
                    name = "Display max. stack size for reagents",
                    width = "full",
                    get = function(info) return RB.DB.profile.displayMaxStackSize end,
                    set = function(info, value)
                        RB.DB.profile.displayMaxStackSize = value
                    end,
                },
                DisplayVendorPrice = {
                    type = "toggle",
                    order = 5,
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
