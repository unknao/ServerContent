local tag = "synergize"
game.SetSkillLevel(3)

hook.Add("OnEntityCreated", tag, function(ent)
    if not ent:IsNPC() then return end
    timer.Simple(0, function()
        ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
    end)
end)