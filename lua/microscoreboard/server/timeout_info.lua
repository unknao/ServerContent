require("nw3")

timer.Create("MicroScore_TimeoutInfo", 3, 0, function()
	for _, ply in pairs(player.GetHumans()) do
		ply:nw3SetBool("IsTimingOut", v:IsTimingOut())
	end
end)
