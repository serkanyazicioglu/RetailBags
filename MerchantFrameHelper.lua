local RB = RetailBags

function RB:InitMerchantSell()
    InitMerchant(GetMerchantItemLink);
    RB:InitMerchantBuyBackLast();
end

function RB:InitMerchantBuyBackList()
    InitMerchant(GetBuybackItemLink);
end

function InitMerchant(func)
    for slotId = 1, 12 do
        local slotName = 'MerchantItem' .. slotId .. 'ItemButton';
        local frame = _G[slotName];

        if (not RB.DB.profile.displayItemQualityBorders) then
            if (frame.RetailBagsBorder) then
                frame.RetailBagsBorder:Hide();
            end
        else
            local merchantItemLink = func(slotId);
            if (merchantItemLink) then
                local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
                    GetItemInfo(merchantItemLink);
                CreateBorder(frame, slotName, quality, 44, 0, 0);
            else
                if (frame.RetailBagsBorder) then
                    frame.RetailBagsBorder:Hide();
                end
            end
        end
    end
end

function RB:InitMerchantBuyBackLast()
    local link = GetBuybackItemLink(1);

    if (link) then
        local quality = link and select(3, GetItemInfo(link)) or nil;
        CreateBorder(MerchantBuyBackItemItemButton, "MerchantBuyBackItemItemButtonFrame", quality, 44, 0, 0);
    else
        if (MerchantBuyBackItemItemButton.RetailBagsBorder) then
            MerchantBuyBackItemItemButton.RetailBagsBorder:Hide();
        end
    end
end
