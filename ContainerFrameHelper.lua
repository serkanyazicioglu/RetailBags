local RB = RetailBags

function RB:InitContainer(frame)
	local bagId = frame:GetID();
	if ContainerFrame_IsBackpack(bagId) then
		if (RB.DB.profile.displaySearchBox) then
			BagItemSearchBox:ClearAllPoints();
			if (RB.DB.profile.displaySortButton) then
				BagItemSearchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -30);
			else
				BagItemSearchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 58, -30);
			end
			BagItemSearchBox:Show();
		else
			BagItemSearchBox:Hide();
		end

		if (RB.DB.profile.displaySortButton) then
			BagItemAutoSortButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -9, -28);
			BagItemAutoSortButton:Show();
		else
			BagItemAutoSortButton:Hide();
		end
	elseif not IsBagOpen(Enum.BagIndex.Backpack) or BagItemSearchBox.anchorBag == frame then
		BagItemSearchBox:ClearAllPoints();
		BagItemSearchBox:Hide();
		BagItemSearchBox.anchorBag = nil;
		BagItemAutoSortButton:ClearAllPoints();
		BagItemAutoSortButton:Hide();
	end

	DisplayBagItemQualityBorders(frame, bagId);
	RB.Core:Debug("InitContainer " .. bagId .. " " .. frame:GetName() .. " " .. frame:GetID());
end

function RB:InitBank()
	local frame = _G["BankFrame"];
	local bagId = Enum.BagIndex.Bank;

	if (RB.DB.profile.displaySearchBox) then
		BankItemSearchBox:ClearAllPoints();

		local right = 0;
		if (RB.DB.profile.displaySortButton) then
			if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
				right = -73;
			else
				right = -36;
			end
		else
			if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
				right = -60;
			else
				right = -10;
			end
		end

		BankItemSearchBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", right, -48);
		BankItemSearchBox:Show();
	else
		BankItemSearchBox:Hide();
	end

	if (RB.DB.profile.displaySortButton) then
		BankItemAutoSortButton:ClearAllPoints();
		local right = 0;
		local top = -48;

		if (RB.DB.profile.displaySearchBox) then
			top = -44;

			if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
				right = -48;
			else
				right = -8;
			end
		else
			if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
				right = -60;
			else
				right = -10;
			end
		end

		BankItemAutoSortButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", right, top);
		BankItemAutoSortButton:Show();
	else
		BankItemAutoSortButton:Hide();
	end

	DisplayBagItemQualityBorders(frame, bagId);
end

function ContainerFrame_IsBackpack(id)
	return id == Enum.BagIndex.Backpack;
end

function GetContainerItemFrameName(bagId, frame, containerNumSlots, slotId)
	if (bagId == Enum.BagIndex.Bank) then
		return "BankFrameItem" .. slotId;
	else
		local slotFrameId = containerNumSlots + 1 - slotId;
		return frame:GetName() .. "Item" .. slotFrameId;
	end
end

function DisplayBagItemQualityBorders(frame, bagId)
	local containerNumSlots = ContainerFrame_GetContainerNumSlots(bagId);

	for slotId = 1, containerNumSlots do
		local slotFrameName = GetContainerItemFrameName(bagId, frame, containerNumSlots, slotId);
		DisplayBagItemSlotBorder(bagId, slotFrameName, slotId);
	end
end

function DisplayBagItemSlotBorder(bagId, slotFrameName, slotId)
	local frame = _G[slotFrameName];
	if (not frame) then
		return;
	end

	if (RB.DB.profile.displayItemQualityBorders and IsBagOpen(bagId)) then
		local itemId = C_Container.GetContainerItemID(bagId, slotId);

		if (itemId) then
			local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID =
				GetItemInfo(itemId);

			if itemQuality and itemQuality ~= Enum.ItemQuality.Poor then
				local isActive = true;
				if (classID == Enum.ItemClass.Questitem) then
					local questInfo = C_Container.GetContainerItemQuestInfo(bagId, slotId);
					if (questInfo and questInfo.questID) then
						isActive = questInfo.isActive;
					end
				end

				CreateBorder(frame, itemQuality, classID, isActive);
				return;
			end
		end
	end

	if (frame.RetailBagsBorder) then
		frame.RetailBagsBorder:Hide();
	end
end
