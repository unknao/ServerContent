local tag = "bot_qol"

hook.Add("PlayerChangedTeam", tag, function(ply, _, new_team)
    if not ply:IsBot() then return end

    local c = team.GetColor(new_team)
    local team_color = Vector(c.r / 255, c.g / 255, c.b / 255)
    ply:SetPlayerColor(team_color)
    ply:SetWeaponColor(team_color)
end)

hook.Add("PlayerSpawn", tag, function(ply)
    if not ply:IsBot() then return end

    timer.Simple(0, function()
        local c = team.GetColor(ply:Team())
        local team_color = Vector(c.r / 255, c.g / 255, c.b / 255)
        ply:SetPlayerColor(team_color)
        ply:SetWeaponColor(team_color)
    end)
end)

local BOT = FindMetaTable("Player")
local bot_actions = {}

function BOT:StartShooting()
    if not self:IsBot() then return end

    bot_actions[self] = function(cmd) cmd:SetButtons(IN_ATTACK) end
end

function BOT:StopShooting()
    if not self:IsBot() then return end

    bot_actions[self] = function(cmd) cmd:ClearButtons() end
    timer.Simple(0, function() bot_actions[self] = nil end)
end


hook.Add("StartCommand", tag, function(ply, cmd)
    if not ply:IsBot() then return end

    if bot_actions[ply] then
        bot_actions[ply](cmd)
    end
end)

hook.Add("EntityRemoved", tag, function(ent)
    if bot_actions[ent] then
        bot_actions[ent] = nil
    end
end)