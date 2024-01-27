local tag = "soundprecache"
require("nw3")
require("stringtable")

local Countdown = false
local soundprecache_cache, soundprecache = table.Count(StringTable(tag):GetTable()), table.Count(StringTable(tag):GetTable())
nw3.SetGlobalInt(tag,  soundprecache)

hook.Add("EntityEmitSound", tag, function(ent)
	soundprecache_cache = soundprecache
	soundprecache = table.Count(StringTable(tag):GetTable())
	if soundprecache_cache ~= soundprecache then nw3.SetGlobalInt(tag, soundprecache) end

	if soundprecache < 16380 then return end
	if Countdown then return false end

	Countdown = true
	ctrl.countdown(30, "Sound precache full(?!), restarting map to prevent crashes...", true, RunConsoleCommand, "changelevel", game.GetMap())
end)