local tag = "onyxhud_player_info"
local onyxhud_player_info_hide = CreateConVar(tag .. "_hide", 0, {FCVAR_ARCHIVE}, "Hide onyxhuds custom player info")

hook.Add("HUDDrawTargetID", tag, function()
    return onyxhud_player_info_hide:GetBool()
end)

surface.CreateFont(tag, {
	font = "Mieghommel",
	size = 200,
	weight = 1200,
	extended = true,
})

local onyxhud_player_info_shown = {}

hook.Add("PostDrawTranslucentRenderables", tag, function(_, skybox)
    if onyxhud_player_info_hide:GetBool() then return end
    if skybox then return end

    local aim = LocalPlayer():GetEyeTrace()
    local ply = aim.Entity
    local dist = aim.HitPos:DistToSqr(EyePos())
    if aim.Entity == ply and ply:IsPlayer() and dist <= 160000 then
        local ang = EyeAngles()
        ang:RotateAroundAxis( ang:Up(), -90 )
        ang:RotateAroundAxis( ang:Forward(), 90 )

        onyxhud_player_info_shown[ply] = {
            ttl = CurTime() + 1,
            hitPos = ply:WorldToLocal(aim.HitPos),
            eyeAngles = ang,
            color = ONYXHUD.Colors[ply:Team()]
        }
    end
    if table.IsEmpty(onyxhud_player_info_shown) then return end


    for ply, tbl in pairs(onyxhud_player_info_shown) do
        if not IsValid(ply) then
            onyxhud_player_info_shown[ply] = nil
            continue
        end
        if tbl.ttl <= CurTime() then
            onyxhud_player_info_shown[ply] = nil
            continue
        end
        if ply:GetPos():DistToSqr(EyePos()) >= 160000 then continue end

        local scale = ply:GetModelScale()

        local alpha_composite = math.min(1 - math.ease.InExpo(dist / (160000 * scale)), math.ease.OutCubic(tbl.ttl - CurTime()))
        if alpha_composite <= 0 then continue end

        surface.SetAlphaMultiplier(alpha_composite)
        cam.Start3D2D(ply:LocalToWorld(tbl.hitPos) - EyeVector() * 10, tbl.eyeAngles, scale * 0.02)
            ONYXHUD.DrawTextShadowed("Health: " .. ply:Health(), tag, 0, 0, tbl.color[1], tbl.color[2], 8, TEXT_ALIGN_TOP, TEXT_ALIGN_RIGHT)
            if ply:Armor() > 0 then
            ONYXHUD.DrawTextShadowed("Armor: " .. ply:Armor(), tag, 0, 210, tbl.color[1], tbl.color[2], 8, TEXT_ALIGN_TOP, TEXT_ALIGN_RIGHT)
            end
        cam.End3D2D()
        surface.SetAlphaMultiplier(1)
    end
end)
