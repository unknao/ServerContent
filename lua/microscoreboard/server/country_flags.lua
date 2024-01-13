local tag = "Micro_Scoreboard_Flags"
local ServerIP = string.gsub(game.GetIPAddress(),":..+","")

hook.Add("PlayerInitialSpawn", tag, function(ply)
	if ply:IsBot() then return end

	local ip = string.gsub(ply:IPAddress(), ":..+", "")
	if string.find(ip, "192.168.0") then ip = ServerIP end --If the ip is local, use the servers ip

	http.Fetch("http://ip-api.com/json/" .. ip,function(str)
		local tbl = util.JSONToTable(str)
		ply:SetNWString("country_code", tbl.countryCode)
		ply:SetNWString("country",tbl.country)
	end)
end)
