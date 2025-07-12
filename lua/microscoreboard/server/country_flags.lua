local tag = "MICRO_SCOREBOARD_Flags"
-- 10.0.0.0/8
-- 172.16.0.0/12
-- 192.168.0.0/16
local net_patterns = {
	"^10",
	"^172.16",
	"^192.168"
}

local function IsClientOnLocalNetwork(ply)
	local ip = string.gsub(ply:IPAddress(), ":.+", "")
	if ip == "loopback" or ip == "127.0.0.1" then
		return true
	elseif ip == game.GetIPAddress() then
		return true
	else
		for i, v in ipairs(net_patterns) do
			if not string.match(ip, v) then continue end

			return true
		end
	end

	return false
end

hook.Add("PlayerInitialSpawn", tag, function(ply)
	if ply:IsBot() then return end

	local ip
	if IsClientOnLocalNetwork(ply) then
		ip = game.GetIPAddress()
	else
		ip = ply:IPAddress()
	end
	ip = string.gsub(ip, ":.+", "")

	http.Fetch("http://ip-api.com/json/" .. ip,function(str)
		local tbl = util.JSONToTable(str)
		ply:nw3SetString("country_code", tbl.countryCode)
		ply:nw3SetString("country",tbl.country)
	end)
end)
