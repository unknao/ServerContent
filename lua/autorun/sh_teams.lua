hook.Add("CreateTeams", "teams_init", function()
	team.SetUp(1, "Users", Color(127, 255, 212), false)
	team.SetUp(2, "Admins", Color(255, 191, 0), false)
	team.SetUp(3, "Bots", Color(58, 171, 117), false)
	team.SetUp(4, "Joining", Color(70, 70, 70), false)
end)

if CLIENT then
	net.Receive("teamchange_networking", function()
		--local ply = net.ReadEntity()
		local ply = net.ReadEntity()
		local old_team = net.ReadUInt(4)
		local new_team = net.ReadUInt(4)
		if not IsValid(ply) then return end

		hook.Run("OnPlayerChangedTeam", ply, old_team, new_team)
	end)
end

if not SERVER then return end
util.AddNetworkString("teamchange_networking")
--How is there not a hook for players changing teams clientside?
local PLAYER = FindMetaTable("Player")
PLAYER._SetTeam = PLAYER._SetTeam or PLAYER.SetTeam

function PLAYER:SetTeam(new_team)
	local old_team = self:Team()
	self:_SetTeam(new_team)

	net.Start("teamchange_networking")
	net.WriteEntity(self)
	net.WriteUInt(old_team, 4)
	net.WriteUInt(new_team, 4)
	net.Broadcast()
end

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
