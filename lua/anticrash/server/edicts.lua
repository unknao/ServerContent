local tag = "edicts"
local AllowCreation = true

local EdictsCount = ents.GetEdictCount()

hook.Add("OnEntityCreated", tag, function()
	EdictsCount = ents.GetEdictCount()
	SetGlobal2Int(tag, EdictsCount)

	if EdictsCount < 8170 then return end
	if not AllowCreation then return end

	AllowCreation = false
	ctrl.countdown(30, "Edicts count too high, restarting map to prevent crashes...", true, RunConsoleCommand, "changelevel", game.GetMap())
end)

hook.Add("EntityRemoved", tag, function()
	timer.Simple(0, function()
		EdictsCount = ents.GetEdictCount()
		SetGlobal2Int(tag, EdictsCount)
	end)
end)

hook.Add("PlayerSpawnObject", tag, function()
	if not AllowCreation then return false end
end)