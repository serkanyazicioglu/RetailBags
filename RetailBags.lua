local addonName, addon = ...
local RB = LibStub("AceAddon-3.0"):NewAddon(addonName);
RetailBags = RB;

RB.defaults = {
	profile = {
		version = 1,
		displayBagsWithCharacterPane = true,
		displaySearchBox = true,
		displaySortButton = true,
		sortBagsRightToLeft = true,
		bagContainerScale = 1,
		displayTooltipItemQuality = true,
		displayTooltipItemLevel = true,
		displayTooltipCraftingReagent = true,
		displayMaxStackSize = true,
		displayTooltipVendorPrice = true,
		displayItemQualityBorders = true
	}
}

local f = CreateFrame("Frame");
f:RegisterEvent('BANKFRAME_OPENED');
f:RegisterEvent('PLAYERBANKSLOTS_CHANGED');
f:RegisterEvent('INSPECT_READY');
f:RegisterEvent('UNIT_INVENTORY_CHANGED');

function RB:OnInitialize()
	self.GUI = LibStub("AceGUI-3.0")
	self.DB = LibStub("AceDB-3.0"):New("RetailBagsDB", RB.defaults, "Default")
	self.BagItemSearchBox = BagItemSearchBox;
	self.BagItemAutoSortButton = BagItemAutoSortButton;

	SetSortBagsRightToLeft(self.DB.profile.sortBagsRightToLeft);
	CONTAINER_SCALE = self.DB.profile.bagContainerScale;
end

hooksecurefunc("ContainerFrame_Update", function(frame)
	RB:InitContainer(frame);
end)

f:SetScript("OnEvent", function(self, event, arg1, arg2)
	if event == "BANKFRAME_OPENED" or event == "PLAYERBANKSLOTS_CHANGED" then
		RB:InitBank();
	elseif event == "INSPECT_READY" then
		RB:InitInspectInventory();
	elseif event == "UNIT_INVENTORY_CHANGED" then
		if (CharacterFrame:IsShown()) then
			RB:InitInventory(CharacterFrame);
		else
			RB:InitInspectInventory();
		end
	end
end)

local match = string.match
local strsplit = strsplit

RB.Colors = {
	yellow    = "|cFFFFFF00",
	white     = "|cFFFFFFFF",
	blue      = "|cFF69CCF0",

	common    = "|cFFFFFFFF",
	uncommon  = "|cFF1EFF00",
	rare      = "|cFF0070DD",
	epic      = "|cFFA335EE",
	legendary = "|cFFFF8000",
	artifact  = "|cFFE6CC80",
};

local function GameTooltip_OnTooltipSetItem(tooltip)
	if not tooltip then return; end

	local _, link = tooltip:GetItem()
	if not link then return; end

	local itemString = match(link, "item[%-?%d:]+")
	local _, itemId = strsplit(":", itemString)
	local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
		GetItemInfo('item:' .. itemId);

	if isCraftingReagent or classId == Enum.ItemClass.Tradegoods then
		if (RB.DB.profile.displayTooltipItemQuality) then
			tooltip:AddLine(RB.Colors.white .. _G["ITEM_QUALITY" .. quality .. "_DESC"]);
		end
		if (RB.DB.profile.displayTooltipCraftingReagent) then
			tooltip:AddLine(RB.Colors.blue .. "Crafting Reagent");
		end
	elseif itemLevel > 1 and (classId == Enum.ItemClass.Weapon or classId == Enum.ItemClass.Armor or classId == Enum.ItemClass.Projectile or classId == Enum.ItemClass.Quiver) then
		if (RB.DB.profile.displayTooltipItemQuality) then
			tooltip:AddLine(RB.Colors.white .. _G["ITEM_QUALITY" .. quality .. "_DESC"]);
		end
		if (RB.DB.profile.displayTooltipItemLevel) then
			tooltip:AddLine("Item Level " .. itemLevel);
		end
	end

	if (RB.DB.profile.displayMaxStackSize and stack > 1) then
		local indent = string.rep(" ", 4);
		tooltip:AddLine("Max Stack:" .. indent .. stack);
	end

	--if (tooltip.shoppingTooltips and tooltip.shoppingTooltips[1]) then
		--print("comparing");
		--hooksecurefunc(tooltip.shoppingTooltips[1], "Show", GameTooltip_OnTooltipSetItem);
		-- tooltip.shoppingTooltips[1]:AddLine("Test TEstesrer");
		-- GameTooltip_OnTooltipSetItem(tooltip.shoppingTooltips[2]);
	--end
end

GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem);

local function GameTooltip_OnSetBagItem(tooltip, bag, slot)
	if RB.DB.profile.displayTooltipVendorPrice and not MerchantFrame:IsVisible() and tooltip and bag and slot then
        local info = C_Container.GetContainerItemInfo(bag, slot)
        if info then
			local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent = GetItemInfo(info.itemID);
            if (sellPrice > 0) then
				GameTooltip_OnTooltipAddMoney(tooltip, sellPrice * info.stackCount, nil);
				tooltip:Show();
			end
        end
    end
end

hooksecurefunc(GameTooltip, 'SetBagItem', GameTooltip_OnSetBagItem);

hooksecurefunc(WorldMapFrame, "Show", function(self)
	if (CharacterFrame:IsShown()) then
		HideUIPanel(CharacterFrame);
	end

	ShowUIPanel(WorldMapFrame);
end);

local function CharacterFrame_VisibilityCallback(frame)
	if (RB.DB.profile.displayBagsWithCharacterPane) then
		HideUIPanel(WorldMapFrame);

		if (frame:IsShown()) then
			OpenAllBags();
		else
			CloseAllBags();
		end
	end

	RB:InitInventory(frame);
end

hooksecurefunc(CharacterFrame, "Hide", CharacterFrame_VisibilityCallback);
hooksecurefunc(CharacterFrame, "Show", CharacterFrame_VisibilityCallback);