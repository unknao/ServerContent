local tag = "synergize"
game.SetSkillLevel(3)

hook.Add("OnEntityCreated", tag, function(ent)
    if not IsValid(ent) then return end
    if not ent:IsNPC() then return end

    timer.Simple(0, function()
        if not IsValid(ent) then return end

        ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
    end)
end)