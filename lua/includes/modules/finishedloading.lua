local tag = "FinishedLoading"
AddCSLuaFile()

if CLIENT then
	hook.Add("Think", tag, function()
		hook.Run(tag)
		hook.Remove("Think", tag)
	end)
end

if not SERVER then return end

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

hook.Add(tag, "PostFinishedLoading",  function(ply)
	timer.Simple(0, function() hook.Run("PostFinishedLoading",  ply) end)
end)

