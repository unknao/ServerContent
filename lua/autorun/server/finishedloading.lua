local tag = "FinishedLoading"
hook.Add("InitPostEntity",tag,function()
	hook.Add("PlayerInitialSpawn", tag, function(ply)
		if ply:IsBot() then return end
		ply._just_spawned = true
	end)
	hook.Add("SetupMove", tag, function(ply, _, ucmd)
		if ply._just_spawned and not ucmd:IsForced() then
			ply._just_spawned = nil
			hook.Run(tag,ply)
		end
	end)
	hook.Remove("InitPostEntity",tag)
end)