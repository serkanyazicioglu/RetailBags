local RB = RetailBags

function CreateBorder(frame, itemQuality, itemClass, isActiveQuest)
	if (itemQuality == Enum.ItemQuality.Poor) then
		if (frame.RetailBagsBorder) then
			frame.RetailBagsBorder:Hide();
		end
	else
		if (not frame.RetailBagsBorder) then
			local f = frame:CreateTexture('ItemButtonBorder', 'OVERLAY');
			f:SetSize(frame:GetWidth(), frame:GetHeight());
			f:SetPoint("CENTER", 0, 0);
			frame.RetailBagsBorder = f;
		end

		if (itemClass == Enum.ItemClass.Questitem) then
			if (isActiveQuest) then
				frame.RetailBagsBorder:SetTexture(TEXTURE_ITEM_QUEST_BORDER);
			else
				frame.RetailBagsBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG);
			end

			frame.RetailBagsBorder:SetVertexColor(1, 1, 1);
		else
			frame.RetailBagsBorder:SetTexture([[Interface\Common\WhiteIconFrame]]);
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
end
