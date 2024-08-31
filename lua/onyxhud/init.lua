local paths = {
	sv = "onyxhud/server/",
	cl = "onyxhud/client/",
	sh = "onyxhud/shared/",
}
if CLIENT then
	require("svg")
	ONYXHUD = ONYXHUD or {}
end

local function LoadFolder(path, realm)
	if realm == "sv" and CLIENT then return end

	local files = file.Find(path .. "*.lua", "LUA")

	for k, v in ipairs(files) do
		local luafile = path .. v
		if realm ~= "sv" then AddCSLuaFile(luafile) end
		if realm == "cl" and SERVER then continue end

		include(luafile)
	end
end

LoadFolder("onyxhud/modules/", "cl")

for k, v in pairs(paths) do
	LoadFolder(v, k)
end

AddCSLuaFile("onyxhud/hudpaint.lua")
if SERVER then return end

include("onyxhud/hudpaint.lua")