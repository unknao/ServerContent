ac_detours = ac_detours or {}
local files = {
	sv = file.Find("anticrash/server/*.lua", "LUA"),
	cl = file.Find("anticrash/client/*.lua", "LUA"),
	sh = file.Find("anticrash/shared/*.lua", "LUA")
}

local short = {sv = SERVER, cl = CLIENT, sh = true}
local path = {
	sv = "anticrash/server/",
	cl = "anticrash/client/",
	sh = "anticrash/shared/"
}

for k, v in pairs(files) do
	for kk, vv in pairs(v) do
		if k != "sv" then AddCSLuaFile(path[k] .. vv) end
		if not short[k] then continue end

		local ok, err = pcall(include, path[k] .. vv)
		if ok then continue end

		local errstr = Format("%s%s %s", path[k], vv, err)
		ErrorNoHalt(errstr)
	end
end