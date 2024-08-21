local Player = FindMetaTable("Player")
Player._SetUserGroup = Player._SetUserGroup or Player.SetUserGroup

hook.Add("PlayerInitialSpawn", "micro_scoreboard_ranks", function(ply)
    ply:nw3SetString("user_group", ply:GetUserGroup())
end)

function Player:SetUserGroup(group)
    self:nw3SetString("user_group", group)
    self:_SetUserGroup(group)
end

