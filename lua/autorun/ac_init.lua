AddCSLuaFile("anticrash/init.lua")

hook.Add("InitPostEntity", "anticrash", function()
	include("anticrash/init.lua")
	hook.Remove("InitPostEntity", "anticrash")
end)
