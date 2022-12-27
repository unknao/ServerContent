local Admins={
	["STEAM_0:1:33890317"]=true, --unknao
	["STEAM_0:0:53756062"]=true, --galaxy
	["STEAM_0:0:47051927"]=true, --3327-NT
	["STEAM_0:1:80004288"]=true, --Yagira
	["STEAM_0:0:441005561"]=true --Mist probably
}
hook.Add("FinishedLoading","admins",function(ply)
	if Admins[ply:SteamID()] then
		ply:SetUserGroup("superadmin")
	end	
end)