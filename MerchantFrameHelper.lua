local RB = RetailBags

function RB:InitMerchantSell()
    InitMerchant(GetMerchantItemLink, MERCHANT_ITEMS_PER_PAGE);
    RB:InitMerchantBuyBackLast();
end

function RB:InitMerchantBuyBackList()
    InitMerchant(GetBuybackItemLink, BUYBACK_ITEMS_PER_PAGE);
end

function InitMerchant(func, count)
    for slotId = 1, count do
        local frame = _G['MerchantItem' .. slotId .. 'ItemButton'];

        if (not RB.DB.profile.displayItemQualityBorders) then
            if (frame.RetailBagsBorder) then
                frame.RetailBagsBorder:Hide();
            end
        else
            local merchantItemLink = func(slotId);
            if (merchantItemLink) then
                local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
                    GetItemInfo(merchantItemLink);
                CreateBorder(frame, quality, classId, 44, 0, 0);
            else
                if (frame.RetailBagsBorder) then
                    frame.RetailBagsBorder:Hide();
                end
            end
        end
    end
end

function RB:InitMerchantBuyBackLast()
    local link = GetBuybackItemLink(GetNumBuybackItems());

    if (link) then
        local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
                    GetItemInfo(link);
        CreateBorder(MerchantBuyBackItemItemButton, quality, classId, 44, 0, 0);
    else
        if (MerchantBuyBackItemItemButton.RetailBagsBorder) then
            MerchantBuyBackItemItemButton.RetailBagsBorder:Hide();
        end
    end
end