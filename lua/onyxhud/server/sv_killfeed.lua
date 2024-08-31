util.AddNetworkString("onyxhud_killfeed")

local remember_for_later = {
    ["prop_vehicle_jeep_old"] = "Jeep",
    ["prop_vehicle_jeep"] = "Jeep",
    ["npc_grenade_frag"] = "Frag Grenade",
    ["crossbow_bolt"] = "Crossbow",
    ["prop_vehicle_airboat"] = "Airboat",
    ["npc_satchel"] = "S.L.A.M.",
    ["grenade_ar2"] = "SMG1 Grenade",
    ["rpg_missile"] = "Missile"
}


local function GetNiceName(ent)
    local class = ent:GetClass()

    if remember_for_later[class] then return remember_for_later[class] end

    if ent.GetPrintName and ent:GetPrintName() ~= "" then
        remember_for_later[class] = ent:GetPrintName()
        return ent:GetPrintName()
    end

    if ent.PrintName then return ent.PrintName end

    local str = string.NiceName(string.match(ent:GetModel(), ".*/(%S+)%."), "_", " ")
    str = string.gsub(str, "%s+%d+.+$", "")
    return str
end

hook.Add("PlayerDeath", "onyxhud_killfeed", function(ply, inf, atk)
    if not IsValid(inf) then return end
    if not IsValid(atk) then return end
    if not atk:IsPlayer() then return end
    if ply == atk then return end

    if inf == atk and inf:IsPlayer() then inf = atk:GetActiveWeapon() end
    net.Start("onyxhud_killfeed")
    net.WriteEntity(atk)
    net.WriteString(GetNiceName(inf))
    net.WriteEntity(ply)
    net.Broadcast()
end)