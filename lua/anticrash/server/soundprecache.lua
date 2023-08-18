local tag = "soundprecache"
require("stringtable")

local Countdown = false
Entity(0):SetNWInt(tag,  table.Count(StringTable(tag):GetTable()))

hook.Add("EntityEmitSound", tag, function(ent)
	local soundprecache = table.Count(StringTable(tag):GetTable())
	Entity(0):SetNWInt(tag, soundprecache)

	if soundprecache < 16380 then return end
	if Countdown then return end

	Countdown = true
	ctrl.countdown(30, "Sound precache full(?!), restarting map to prevent crashes...", true, RunConsoleCommand, "changelevel", game.GetMap())
end)