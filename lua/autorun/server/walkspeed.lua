require("finishedloading")

hook.Add("FinishedLoading", "walkspeed", function(ply)
    ply:SetWalkSpeed(150)
    ply:SetSlowWalkSpeed(100)
    ply:SetRunSpeed(300)
    ply:SetMaxSpeed(300)
end)