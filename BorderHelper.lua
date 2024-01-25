function CreateBorder(frame, slotFrameName, itemQuality, size)
	if (not frame.RetailBagsBorder) then
		if (not size) then
			size = 43;
		end

		local f = CreateFrame("Frame", nil, frame, "BackdropTemplate");
		f:SetPoint("CENTER", 0, -1);
		f:SetSize(size, size);
		f:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			edgeSize = 17
		});
		f:SetBackdropColor(0, 0, 0, 0);
		frame.RetailBagsBorder = f;
	end
	local color = ITEM_QUALITY_COLORS[itemQuality];
	frame.RetailBagsBorder:SetBackdropBorderColor(color.r, color.g, color.b);
	frame.RetailBagsBorder:Show();
end
