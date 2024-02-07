local RB = RetailBags

function RB:InitAuctionBrowseItems()
    local type = "list";
    local frameName = "BrowseButton";
    local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame);
    RB:InitAuctionItems(type, frameName, offset);
end

function RB:InitAuctionOwnedItems()
    local type = "owner";
    local frameName = "AuctionsButton";
    RB:InitAuctionItems(type, frameName, 0);
end

function RB:InitAuctionBidItems()
    local type = "bidder";
    local frameName = "BidButton";
    RB:InitAuctionItems(type, frameName, 0);
end

function RB:InitAuctionItems(type, frameName, offset)
    local auctionItems = GetNumAuctionItems(type);
    if (auctionItems > 0) then
        for index = 1, auctionItems do
            local name, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, itemId, _ = GetAuctionItemInfo(type, offset + index);
            if (name) then
                local frame = _G[frameName .. index .. "Item"];
                if (frame) then
                    if (not RB.DB.profile.displayItemQualityBorders) then
                        if (frame.RetailBagsBorder) then
                            frame.RetailBagsBorder:Hide();
                        end
                    else
                        local itemName, _, quality, itemLevel, _, _, _, stack, slot, _, sellPrice, classId, subClassId, bindType, expacID, setID, isCraftingReagent =
                            GetItemInfo(itemId);

                        CreateBorder(frame, quality, classId, false);
                    end
                end
            end
        end
    end
end
