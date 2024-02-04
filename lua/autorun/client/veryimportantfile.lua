hook.Add("HUDPaint", "fullyloaded", function()
	system.FlashWindow()
	hook.Remove("HUDPaint", "fullyloaded")
end)