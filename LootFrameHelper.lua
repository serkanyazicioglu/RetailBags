local RB = RetailBags

function RB:InitLootFrame()
    if (LootFrame.numLootItems) then
        RB.Core:Debug("LootFrame shown " .. LootFrame.numLootItems .. " " .. LOOTFRAME_NUMBUTTONS);

        if (LootFrame.numLootItems > 0) then
            local numLootItems = LootFrame.numLootItems;

            local numLootToShow = LOOTFRAME_NUMBUTTONS;
            if (numLootItems > LOOTFRAME_NUMBUTTONS) then
                numLootToShow = numLootToShow - 1;
            end

            for index = 1, LOOTFRAME_NUMBUTTONS do
                RB:LootFrame_UpdateButton(numLootToShow, index);
            end
        end
    end
end

function RB:LootFrame_UpdateButton(numLootToShow, index)
    local frame = _G["LootButton" .. index];

    if (not frame) then
        return;
    end

    if (RB.DB.profile.displayItemQualityBorders) then
        local slot = (numLootToShow * (LootFrame.page - 1)) + index;
        local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive =
            GetLootSlotInfo(slot);
        if (lootName and not currencyID) then
            if lootQuality then
                local slotLink = GetLootSlotLink(slot);
                if (slotLink) then
                    local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
                        GetItemInfo(slotLink);
                    if (itemName) then
                        local isActiveQuest = true;
                        if (isQuestItem and questID) then
                            isActiveQuest = isActive;
                        end

                        CreateBorder(frame, quality, classId, isActiveQuest);
                        return;
                    end
                end
            end
        end
    end

    if (frame.RetailBagsBorder) then
        frame.RetailBagsBorder:Hide();
    end
end
