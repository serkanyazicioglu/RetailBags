function CreateBorder(frame, slotFrameName, itemQuality, size)
	if (not frame.RetailBagsBorder) then
		if (not size) then
			size = 68;
		end

		local border = frame:CreateTexture(slotFrameName .. 'Quality', 'OVERLAY');
		border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
		border:SetBlendMode('ADD');
		border:SetHeight(size);
		border:SetWidth(size);
		border:SetPoint('CENTER', frame, 'CENTER', 0, 1);
		frame.RetailBagsBorder = border;
	end
	local color = ITEM_QUALITY_COLORS[itemQuality];
	frame.RetailBagsBorder:SetVertexColor(color.r, color.g, color.b);
	frame.RetailBagsBorder:SetAlpha(0.425);
	frame.RetailBagsBorder:Show();
end
