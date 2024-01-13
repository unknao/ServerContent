MICRO_SCORE = {
	paths = {
		sv = "microscoreboard/server/",
		cl = "microscoreboard/client/",
		sh = "microscoreboard/shared/",
	},
	Frame_Color = Color(30, 30, 30, 200),
	Player_BGColor = Color(255, 255 ,255),
	Player_BGColor_Hovered = Color(219, 219 ,219),
	Player_Timeout_BGColor = Color(255, 200, 200),
	Player_Timeout_BGColor_Hovered = Color(207, 160, 160),
	Player_PingColor = Color(80, 0, 0)
}


local function LoadFolder(path, realm)
	if realm == "sv" and CLIENT then return end

	local files = file.Find(path .. "*.lua", "LUA")

	for k, v in pairs(files) do
		local luafile = path .. v
		if realm ~= "sv" then AddCSLuaFile(luafile) end
		if realm == "cl" and SERVER then continue end

		include(luafile)
	end
end

for k, v in pairs(MICRO_SCORE.paths) do
	LoadFolder(v, k)
end

AddCSLuaFile("microscoreboard/scoreboard.lua")
if SERVER then return end

include("microscoreboard/scoreboard.lua")
