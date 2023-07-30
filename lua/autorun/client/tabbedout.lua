hook.Add("PostDrawHUD", "Tabbedout", function()
	if system.HasFocus() then return end
	
	surface.SetDrawColor(255, 0, 0, 255)
	surface.DrawOutlinedRect(-1, -1, ScrW() + 1, ScrH() + 1, 2)
end)