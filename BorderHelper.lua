local RB = RetailBags

function CreateBorder(frame, itemQuality, itemClass)
	if (not frame.RetailBagsBorder) then
		local f = frame:CreateTexture('ItemButtonBorder', 'OVERLAY');
		if (itemClass == Enum.ItemClass.Questitem) then
			f:SetTexture(TEXTURE_ITEM_QUEST_BORDER);
		else
			f:SetTexture([[Interface\Common\WhiteIconFrame]]);
		end

		f:SetSize(frame:GetWidth(), frame:GetHeight());
		f:SetPoint("CENTER", 0, 0);
		frame.RetailBagsBorder = f;
	end
	
	if (itemClass ~= Enum.ItemClass.Questitem) then
		local color;
		if (itemClass == Enum.ItemClass.Tradegoods and RB.DB.profile.makeReagentBordersBlue) then
			color = CreateColor(0.300, 0.780, 0.875);
		else
			color = BAG_ITEM_QUALITY_COLORS[itemQuality];
		end
		frame.RetailBagsBorder:SetVertexColor(color.r, color.g, color.b);
	end
	
	frame.RetailBagsBorder:Show();
end
