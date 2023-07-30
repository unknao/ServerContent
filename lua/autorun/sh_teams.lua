team.SetUp(1, "Users", Color(100, 200, 180), false)
team.SetUp(2, "Admins", Color(200, 180, 100), false)
team.SetUp(3, "Bots", Color(70, 150, 70), false)
team.SetUp(4, "Joining", Color(70, 70, 70), false)

if not SERVER then return end

require("finishedloading")

local Admins={
	["STEAM_0:1:33890317"] = true, --unknao
	["STEAM_0:0:53756062"] = true, --galaxy
}

hook.Add("PlayerInitialSpawn", "joining", function(ply)
	timer.Simple(0, function()
		ply:SetNoCollideWithTeammates(false)
		ply:SetTeam(ply:IsBot() and 3 or 4)
	end)
end)

hook.Add("FinishedLoading", "setup_teams", function(ply)
	if Admins[ply:SteamID()] then
			ply:SetUserGroup("superadmin")
	end	

	ply:SetTeam(ply:IsSuperAdmin() and 2 or 1)
end)
	