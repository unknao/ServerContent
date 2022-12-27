if CLIENT then
	include("scoreboard/scoreboard.lua")
end
if SERVER then
    AddCSLuaFile("scoreboard/scoreboard.lua")
    include("scoreboard/sv_flags.lua")
end