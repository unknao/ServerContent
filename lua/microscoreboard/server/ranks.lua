local playermeta = FindMetaTable("Player")
require("finishedloading")
playermeta._SetUserGroup = playermeta._SetUserGroup or playermeta.SetUserGroup

hook.Add("FinishedLoading", "micro_scoreboard_ranks", function(ply)
    ply:nw3SetString("user_group", ply:GetUserGroup())
end)

function playermeta:SetUserGroup(group)
    self:nw3SetString("user_group", group)
    self:_SetUserGroup(group)
end

