local tag = "edicts"
local AllowCreation = true

local EdictsCount = ents.GetEdictCount()

hook.Add("InitPostEntity", tag, function()
	EdictsCount = ents.GetEdictCount()
	Entity(0):SetNWInt(tag, EdictsCount)
	hook.Remove("InitPostEntity", tag)
end)

hook.Add("OnEntityCreated", tag, function()
	EdictsCount = ents.GetEdictCount()
	Entity(0):SetNWInt(tag, ents.GetEdictCount())
	
	if EdictsCount < 8170 then return end
	if not AllowCreation then return end
	
	AllowCreation = false
	ctrl.countdown(30, "Edicts table full, restarting map to prevent crashes...", true, RunConsoleCommand, "changelevel", game.GetMap())
end)

hook.Add("EntityRemoved", tag, function()
	timer.Simple(0, function()
		EdictsCount = ents.GetEdictCount()
		Entity(0):SetNWInt(tag, ents.GetEdictCount())
	end)
end)
	
hook.Add("PlayerSpawnObject", tag, function() 
	if not AllowCreation then return false end 
end)