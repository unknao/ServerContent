local WM_ENABLE = CreateConVar("wintermode_enabled", "1", {FCVAR_ARCHIVE}, "Enables map texture conversion to a more snowy landscape (requires rejoin to take effect).")

if not WM_ENABLE:GetBool() then return end

AddCSLuaFile("wintermode/init.lua")
include("wintermode/init.lua")