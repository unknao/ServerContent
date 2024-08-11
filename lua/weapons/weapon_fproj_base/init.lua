AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_projectile.lua")
AddCSLuaFile("shared.lua")
include("sh_projectile.lua")
include("shared.lua")

util.AddNetworkString("fproj_shoot")