local tag = "soundprecache"
require("stringtable")

local Countdown = false
SetGlobal2Int(tag,  table.Count(StringTable(tag):GetTable()))

hook.Add("EntityEmitSound", tag, function(ent)
	local soundprecache = table.Count(StringTable(tag):GetTable())
	SetGlobal2Int(tag, soundprecache)

	if soundprecache < 16380 then return end
	if Countdown then return false end

	Countdown = true
	ctrl.countdown(30, "Sound precache full(?!), restarting map to prevent crashes...", true, RunConsoleCommand, "changelevel", game.GetMap())
end)