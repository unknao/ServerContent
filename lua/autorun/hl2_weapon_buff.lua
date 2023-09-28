local base_damage = {
    ["AR2"] = 16.5,
    ["Pistol"] = 12,
    ["SMG1"] = 7.5,
    ["357"] = 112.5,
    ["Buckshot"] = 13.5,
}

hook.Add("EntityFireBullets", "hl2_weapons_buff", function(ent, bullet)
    local dmg_modified = base_damage[bullet.AmmoType]
    if not dmg_modified then return end

    bullet.Callback = function(_, _, dmg)
        dmg:SetDamage(dmg_modified)
    end
    return true
end)