local tag = "Playtime"
require("finishedloading")
require("nw3")

hook.Add("PlayerInitialSpawn", tag, function(ply)
    if ply:IsBot() then return end

    if not ply:GetPData("FirstJoin") then ply:SetPData("FirstJoin", os.time()) end
    ply._joined = CurTime()
    ply:nw3SetInt("Joined", CurTime())
    if ply:GetPData(tag) then
        ply._playtime = tonumber(ply:GetPData(tag))
        ply:nw3SetInt(tag, ply._playtime)
        return
    end

    ply:SetPData(tag, 0)
    ply._playtime = 0
end)

hook.Add("FinishedLoading", tag, function(ply)
    ply:SetPData("LastSeen", os.time())
end)

timer.Create(tag, 600, 0, function()
    for _, ply in ipairs(player.GetHumans()) do
        ply:SetPData(tag, ply._playtime + (CurTime() - ply._joined))
    end
end)

hook.Add("PlayerDisconnected", tag, function(ply)
    if ply:IsBot() then return end

    ply:SetPData(tag, ply._playtime + (CurTime() - ply._joined))
    ply:SetPData("LastSeen", os.time())
end)

hook.Add("ShutDown", tag, function()
    for _, ply in ipairs(player.GetHumans()) do
        ply:SetPData("LastSeen", os.time())
        ply:SetPData(tag, ply._playtime + (CurTime() - ply._joined))
    end
end)