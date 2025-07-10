--Glacial hp regen
gameevent.Listen("player_hurt")
hook.Add("player_hurt", "glacial_hp_regen", function(data)
    local health = data.health
    if health >= 100 or health <= 0 then
        return
    end

    local timer_id = data.userid .. "_hp_regen"
    if not timer.Exists(timer_id) then
        local ply = Player(data.userid)

        timer.Create(timer_id, 60, 0, function()
            local hp = ply:Health()
            if hp >= 100 or health <= 0 then
                timer.Stop(timer_id)
                return
            end

            hp = hp + 10
            ply:SetHealth(math.min(health, 100))
            if health >= 100 then
                timer.Stop(timer_id)
            end
        end)
    else
        timer.Start(timer_id)
    end
end)