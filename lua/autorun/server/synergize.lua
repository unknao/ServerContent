local tag = "synergize"
game.SetSkillLevel(3)
	
hook.Add("OnEntityCreated", tag, function(ent)
    if not ent:IsNPC() then return end
     ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
end)