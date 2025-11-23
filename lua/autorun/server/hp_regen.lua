hook.Add("PostEntityTakeDamage", "Glacial_HP_Regen", function(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local timer_id = ply:UserID() .. "_hp_regen"
    if not timer.Exists(timer_id) then
        timer.Create(timer_id, 60, 0, function()
            local hp = ply:Health()
            if hp >= 100 or hp <= 0 then
                timer.Stop(timer_id)
                return
            end

            hp = hp + 10
            ply:SetHealth(math.min(hp, 100))
            if hp >= 100 then
                timer.Stop(timer_id)
            end
        end)
    else
        timer.Start(timer_id)
    end
end)