timer.Create("MicroScore_TimeoutInfo", 4, 0, function()
	for _, ply in pairs(player.GetHumans()) do
		ply:nw3SetBool("IsTimingOut", ply:IsTimingOut())
	end
end)
