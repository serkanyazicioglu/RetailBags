local RB = RetailBags

function RB:InitContainer(frame)
	local bagId = frame:GetID();
	if ContainerFrame_IsBackpack(bagId) then
		BagItemSearchBox:ClearAllPoints();
		BagItemSearchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 50, -30)

		if (RB.DB.profile.displaySearchBox) then
			BagItemSearchBox:Show();
		end

		BagItemAutoSortButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -9, -28);

		if (RB.DB.profile.displaySortButton) then
			BagItemAutoSortButton:Show();
		end
	elseif BagItemSearchBox.anchorBag == frame then
		BagItemSearchBox:ClearAllPoints();
		BagItemSearchBox:Hide();
		BagItemSearchBox.anchorBag = nil;
		BagItemAutoSortButton:ClearAllPoints();
		BagItemAutoSortButton:Hide();
	end

	if (IsBagOpen(bagId)) then
		DisplayBagItemQualityBorders(bagId);
	end
end

function RB:InitBank()
	local frame = _G["BankFrame"];
	local bagId = Enum.BagIndex.Bank;
	BankItemAutoSortButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -60, -50);

	if (RB.DB.profile.displaySortButton) then
		BankItemAutoSortButton:Show();
	end

	DisplayBagItemQualityBorders(bagId);
end

function ContainerFrame_IsBackpack(id)
	return id == Enum.BagIndex.Backpack;
end

function GetContainerItemFrameName(bagId, containerNumSlots, slotId)
	if (bagId == Enum.BagIndex.Bank) then
		return "BankFrameItem" .. slotId;
	else
		local slotFrameId = containerNumSlots + 1 - slotId;
		return "ContainerFrame" .. bagId + 1 .. "Item" .. slotFrameId;
	end
end

function ContainerFrame_GetContainerNumSlots(bagId)
	local currentNumSlots = C_Container.GetContainerNumSlots(bagId);
	local maxNumSlots = currentNumSlots;

	if bagId == Enum.BagIndex.Backpack and not IsAccountSecured() then
		-- If your account isn't secured then the max number of slots you can have in your backpack is 4 more than your current
		maxNumSlots = currentNumSlots + 4;
	end

	return maxNumSlots, currentNumSlots;
end

function DisplayBagItemQualityBorders(bagId)
	local containerNumSlots = ContainerFrame_GetContainerNumSlots(bagId);

	for slotId = 1, containerNumSlots do
		local slotFrameName = GetContainerItemFrameName(bagId, containerNumSlots, slotId);
		DisplayBagItemSlotBorder(bagId, slotFrameName, slotId);
	end
end

function DisplayBagItemSlotBorder(bagId, slotFrameName, slotId)
	local frame = _G[slotFrameName];
	if (frame) then
		if (not RB.DB.profile.displayItemQualityBorders) then
			if (frame.RetailBagsBorder) then
				frame.RetailBagsBorder:Hide();
			end
		else
			local itemId = C_Container.GetContainerItemID(bagId, slotId);

			if (itemId) then
				local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID = GetItemInfo(itemId);
				if itemQuality and itemQuality ~= Enum.ItemQuality.Poor then
					CreateBorder(frame, itemQuality, classID);
				end
			elseif (frame.RetailBagsBorder) then
				frame.RetailBagsBorder:Hide();
			end
		end
	end
end
