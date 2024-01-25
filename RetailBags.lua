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
		displayTooltipVendorPrice = true,
	}
}

function RB:OnInitialize()
	self.GUI = LibStub("AceGUI-3.0")
	self.DB = LibStub("AceDB-3.0"):New("RetailBagsDB", RB.defaults, "Default")
	self.BagItemSearchBox = BagItemSearchBox;
	self.BagItemAutoSortButton = BagItemAutoSortButton;

	SetSortBagsRightToLeft(self.DB.profile.sortBagsRightToLeft);
	CONTAINER_SCALE = self.DB.profile.bagContainerScale;
end

hooksecurefunc("ContainerFrame_Update", function(self)
	if ContainerFrame_IsBackpack(self:GetID()) then
		BagItemSearchBox:SetParent(self);
		BagItemSearchBox:ClearAllPoints();
		BagItemSearchBox:SetPoint("TOPLEFT", self, "TOPLEFT", 50, -30)
		BagItemSearchBox.anchorBag = self;

		if (RB.DB.profile.displaySearchBox) then
			BagItemSearchBox:Show();
		end

		BagItemAutoSortButton:SetParent(self);
		BagItemAutoSortButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -9, -28);

		if (RB.DB.profile.displaySortButton) then
			BagItemAutoSortButton:Show();
		end
	elseif BagItemSearchBox.anchorBag == self then
		BagItemSearchBox:ClearAllPoints();
		BagItemSearchBox:Hide();
		BagItemSearchBox.anchorBag = nil;
		BagItemAutoSortButton:ClearAllPoints();
		BagItemAutoSortButton:Hide();
	end
end)

function ContainerFrame_IsBackpack(id)
	return id == Enum.BagIndex.Backpack;
end

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

	local count = 1;
	if (stack > 1) then
		local focusedItem = GetMouseFocus();
		if (focusedItem) then
			count = focusedItem.count or (focusedItem.Count and focusedItem.Count:GetText()) or
				(focusedItem.Quantity and focusedItem.Quantity:GetText())
			--or (bn and _G[bn] and _G[bn]:GetText())
			count = tonumber(count) or 1
			if count <= 1 then
				count = 1
			end
		end
	end

	if isCraftingReagent or classId == Enum.ItemClass.Tradegoods then
		--local r,g,b,hex = GetItemQualityColor(quality);
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

		--print(itemName .. " " .. itemLevel);

		if (tooltip.shoppingTooltips) then
			--hooksecurefunc(tooltip.shoppingTooltips[1], "Show", GameTooltip_OnTooltipSetItem);
			-- GameTooltip_OnTooltipSetItem(tooltip.shoppingTooltips[1]);
			-- GameTooltip_OnTooltipSetItem(tooltip.shoppingTooltips[2]);
		end
	end

	if (RB.DB.profile.displayTooltipVendorPrice and sellPrice > 0) then
		GameTooltip_OnTooltipAddMoney(tooltip, sellPrice * count, nil);
	end

	--GameTooltip_CalculatePadding(tooltip);
end

GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem);

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
end

hooksecurefunc(CharacterFrame, "Hide", CharacterFrame_VisibilityCallback);
hooksecurefunc(CharacterFrame, "Show", CharacterFrame_VisibilityCallback);
