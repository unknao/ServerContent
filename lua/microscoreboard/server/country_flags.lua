local tag = "MICRO_SCOREBOARDboard_Flags"

hook.Add("PlayerInitialSpawn", tag, function(ply)
	if ply:IsBot() then return end

	local ip = string.gsub(ply:IPAddress(), ":.+", "")
	if string.find(ip, "192.168.0") then --If the ip is local, use the servers ip
		ip = string.gsub(game.GetIPAddress(),":.+","")
	end

	http.Fetch("http://ip-api.com/json/" .. ip,function(str)
		local tbl = util.JSONToTable(str)
		ply:nw3SetString("country_code", tbl.countryCode)
		ply:nw3SetString("country",tbl.country)
	end)
end)
