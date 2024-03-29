local RB = RetailBags

function RB:InitMerchantSell()
    InitMerchant(GetMerchantItemLink, MERCHANT_ITEMS_PER_PAGE, MerchantFrame.page);
    RB:InitMerchantBuyBackLast();
end

function RB:InitMerchantBuyBackList()
    InitMerchant(GetBuybackItemLink, BUYBACK_ITEMS_PER_PAGE, 1);
end

function InitMerchant(func, count, pageIndex)
    for slotId = 1, count do
        InitMerchantSlot(func, count, pageIndex, slotId)
    end
end

function InitMerchantSlot(func, count, pageIndex, slotId)
    local frame = _G['MerchantItem' .. slotId .. 'ItemButton'];

    if (not frame) then
        return;
    end

    if (RB.DB.profile.displayItemQualityBorders) then
        local index = ((pageIndex - 1) * count) + slotId;
        local merchantItemLink = func(index);
        if (merchantItemLink) then
            local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
                GetItemInfo(merchantItemLink);

            if quality then
                local color = ITEM_QUALITY_COLORS[quality];
                _G["MerchantItem" .. slotId].Name:SetTextColor(color.r, color.g, color.b);

                CreateBorder(frame, quality, classId, true);
                return;
            end
        end
    end

    if (frame.RetailBagsBorder) then
        frame.RetailBagsBorder:Hide();
    end
end

function RB:InitMerchantBuyBackLast()
    if (RB.DB.profile.displayItemQualityBorders) then
        local link = GetBuybackItemLink(GetNumBuybackItems());

        if (link) then
            local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
                GetItemInfo(link);
            if quality then
                CreateBorder(MerchantBuyBackItemItemButton, quality, classId, true);
                local color = ITEM_QUALITY_COLORS[quality];
                MerchantBuyBackItem.Name:SetTextColor(color.r, color.g, color.b);
                return;
            end
        end
    end

    if (MerchantBuyBackItemItemButton.RetailBagsBorder) then
        MerchantBuyBackItemItemButton.RetailBagsBorder:Hide();
    end
end
