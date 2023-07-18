team.SetUp(1, "Users", Color(70, 150, 120), false)
team.SetUp(2, "Admins", Color(100, 100, 170), false)
team.SetUp(3, "Bots", Color(70, 150, 70), false)
team.SetUp(4, "Joining", Color(100, 100, 100), false)

if not SERVER then return end

require("finishedloading")

local Admins={
	["STEAM_0:1:33890317"] = true, --unknao
	["STEAM_0:0:53756062"] = true, --galaxy
}

hook.Add("PlayerInitialSpawn", "joining", function(ply)
	
	timer.Simple(0, function()
		ply:SetNoCollideWithTeammates(false)
		local bot = ply:IsBot() and 3 or 4
		ply:SetTeam(bot)
	end)
	
end)

hook.Add("FinishedLoading", "setup_teams", function(ply)
	
	if Admins[ply:SteamID()] then
			ply:SetUserGroup("superadmin")
	end	
	
	local assign_to = ply:IsSuperAdmin() and 2 or 1
	ply:SetTeam(assign_to)
	
end)
	