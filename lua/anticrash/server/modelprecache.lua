local tag = "modelprecache"

require("nw3")
require("stringtable")

local AllowCreation = true
local modelprecache_cache, modelprecache = table.Count(StringTable(tag):GetTable()), table.Count(StringTable(tag):GetTable())
nw3.SetGlobalInt(tag,  modelprecache)

hook.Add("OnEntityCreated", tag, function(ent)
	modelprecache_cache = modelprecache
	modelprecache = table.Count(StringTable(tag):GetTable())
	if modelprecache_cache ~= modelprecache then nw3.SetGlobalInt(tag,  modelprecache) end

	if modelprecache < 4090 then return end
	if not countdown then return end

	ent:SetModel("models/props_c17/streetsign004e.mdl")
	AllowCreation = false
	ctrl.countdown(30, "Model precache full, restarting map to prevent crashes...", true, RunConsoleCommand, "changelevel", game.GetMap())

	return false
end)

hook.Add("PlayerSpawnObject", tag, function()
	if not AllowCreation then return false end
end)