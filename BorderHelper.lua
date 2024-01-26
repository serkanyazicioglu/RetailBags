function CreateBorder(frame, itemQuality, size, x, y)
	if (not frame.RetailBagsBorder) then
		if (not size) then
			size = 43;
		end
		if (not x) then
			x = 0;
		end
		if (not y) then
			y = -1;
		end

		local f = CreateFrame("Frame", nil, frame, "BackdropTemplate");
		f:SetPoint("CENTER", x, y);
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
