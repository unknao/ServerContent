local tag = "flags"
hook.Add("PlayerInitialSpawn",tag,function(ply)
	if ply:IsBot() then return end
	local ip = string.find(ply:IPAddress(),"192.168.0")~=nil and "5.20.67.65" or string.gsub(ply:IPAddress(),":..+","")
	http.Fetch("http://ip-api.com/json/"..ip,function(str)
		local tbl = util.JSONToTable(str)
		ply:SetNWString("country_code","materials/flags16/"..tbl.countryCode..".png")
		ply:SetNWString("country",tbl.country)
	end) 
end)

hook.Add("Tick","datastreamed",function() 
	for k,v in pairs(player.GetAll()) do
		v:SetNWBool("timeout",v:IsTimingOut())
	end
	Entity(0):SetNWInt("edicts",ents.GetEdictCount())
end)