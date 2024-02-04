team.SetUp(1, "Users", Color(127, 255, 212), false)
team.SetUp(2, "Admins", Color(255, 191, 0), false)
team.SetUp(3, "Bots", Color(58, 171, 117), false)
team.SetUp(4, "Joining", Color(70, 70, 70), false)

if not SERVER then return end

require("finishedloading")

hook.Add("PlayerInitialSpawn", "joining", function(ply)
	timer.Simple(0, function()
		ply:SetNoCollideWithTeammates(false)
		ply:SetTeam(ply:IsBot() and 3 or 4)
	end)
end)

hook.Add("FinishedLoading", "setup_teams", function(ply)
	ply:SetTeam(ply:IsSuperAdmin() and 2 or 1)
end)
