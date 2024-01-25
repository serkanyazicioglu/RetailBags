function CreateBorder(frame, slotFrameName, itemQuality)
	if (not frame.RetailBagsBorder) then
		local border = frame:CreateTexture(slotFrameName .. 'Quality', 'OVERLAY');
		border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
		border:SetBlendMode('ADD');
		border:SetHeight(68);
		border:SetWidth(68);
		border:SetPoint('CENTER', frame, 'CENTER', 0, 1);
		frame.RetailBagsBorder = border;
	end
	local color = ITEM_QUALITY_COLORS[itemQuality];
	frame.RetailBagsBorder:SetVertexColor(color.r, color.g, color.b);
	frame.RetailBagsBorder:SetAlpha(0.425);
	frame.RetailBagsBorder:Show();
end