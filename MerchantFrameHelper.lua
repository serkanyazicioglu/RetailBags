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

                if quality then
                    local color = ITEM_QUALITY_COLORS[quality];
                    _G["MerchantItem" .. slotId].Name:SetTextColor(color.r, color.g, color.b);
                    
                    -- if (quality == Enum.ItemQuality.Common) then
                    --     quality = Enum.ItemQuality.Poor;
                    -- end

                    CreateBorder(frame, quality, classId);
                end
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
        if quality then
            CreateBorder(MerchantBuyBackItemItemButton, quality, classId);
            local color = ITEM_QUALITY_COLORS[quality];
            MerchantBuyBackItem.Name:SetTextColor(color.r, color.g, color.b);
            return;
        end
    end

    if (MerchantBuyBackItemItemButton.RetailBagsBorder) then
        MerchantBuyBackItemItemButton.RetailBagsBorder:Hide();
    end
end
