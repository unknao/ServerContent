local tag = "modelprecache"

require("stringtable")

local AllowCreation = true

hook.Add("OnEntityCreated", tag, function(ent)
	local modelsprecached = table.Count(StringTable(tag):GetTable())
	SetGlobal2Int(tag,  modelsprecached)

	if modelsprecached < 4090 then return end
	if not countdown then return end

	ent:SetModel("models/props_c17/streetsign004e.mdl")
	AllowCreation = false
	ctrl.countdown(30, "Model precache full, restarting map to prevent crashes...", true, RunConsoleCommand, "changelevel", game.GetMap())

	return false
end)

hook.Add("PlayerSpawnObject", tag, function()
	if not AllowCreation then return false end
end)