local Run_Speed = CreateConVar("sv_runspeed", "150", FCVAR_NOTIFY, "Sets the normal walk speed of players")
local Walk_Speed = CreateConVar("sv_walkspeed", "100", FCVAR_NOTIFY, "Sets the slow walking speed of players")
local Sprint_Speed = CreateConVar("sv_sprintspeed", "300", FCVAR_NOTIFY, "Sets the sprint speed of players")

cvars.AddChangeCallback("sv_runspeed", function(_, _, new)
    for _, ply in ipairs(player.GetAll()) do
        ply:SetWalkSpeed(tonumber(new))
    end
end)

cvars.AddChangeCallback("sv_walkspeed", function(_, _, new)
    for _, ply in ipairs(player.GetAll()) do
        ply:SetSlowWalkSpeed(tonumber(new))
    end
end)

cvars.AddChangeCallback("sv_sprintspeed", function(_, _, new)
    for _, ply in ipairs(player.GetAll()) do
        ply:SetRunSpeed(tonumber(new))
    end
end)

hook.Add("PlayerInitialSpawn", "walkspeed", function(ply)
    timer.Simple(0, function()
        ply:SetWalkSpeed(Run_Speed:GetInt())
        ply:SetSlowWalkSpeed(Walk_Speed:GetInt())
        ply:SetRunSpeed(Sprint_Speed:GetInt())
    end)
end)