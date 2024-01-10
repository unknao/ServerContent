local tag = "Playtime"
require("finishedloading")

hook.Add("PlayerInitialSpawn", tag, function(ply)
    if not ply:GetPData("FirstJoin") then ply:SetPData("FirstJoin", os.time()) end
    ply._joined = CurTime()
    ply:SetNWInt("Joined", CurTime())
    if ply:GetPData(tag) then
        ply._playtime = ply:GetPData(tag)
        ply:SetNWInt(tag, ply:GetPData(tag))
        return
    end

    ply:SetPData(tag, 0)
    ply._playtime = 0
end)

hook.Add("PostFinishedLoading", tag, function(ply)
    ply:SetPData("LastSeen", os.time())
end)

timer.Create(tag, 600, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsBot() then continue end

        ply:SetPData(tag, ply._playtime + (CurTime() - ply._joined))
    end
end)

hook.Add("PlayerDisconnected", tag, function(ply)
    if ply:IsBot() then return end

    ply:SetPData(tag, ply._playtime + (CurTime() - ply._joined))
    ply:SetPData("LastSeen", os.time())
end)

hook.Add("ShutDown", tag, function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsBot() then continue end

        ply:SetPData("LastSeen", os.time())
        ply:SetPData(tag, ply._playtime + (CurTime() - ply._joined))
    end
end)