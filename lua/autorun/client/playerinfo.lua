local tag = "onyxhud_player_info"
hook.Add("HUDDrawTargetID", tag, function()
    return false
end)

surface.CreateFont(tag, {
	font = "Mieghommel",
	size = 200,
	weight = 1200,
	extended = true,
})

local onyxhud_player_info_shown = {}

hook.Add("PostDrawTranslucentRenderables", tag, function(_, skybox)
    if skybox then return end

    local aim = LocalPlayer():GetEyeTrace()
    local ply = aim.Entity
    local dist = aim.HitPos:DistToSqr(EyePos())
    if aim.Entity == ply and ply:IsPlayer() and dist <= 160000 then
        local ang = EyeAngles()
        ang:RotateAroundAxis( ang:Up(), -90 )
        ang:RotateAroundAxis( ang:Forward(), 90 )

        onyxhud_player_info_shown[ply] = {
            TTL = CurTime() + 1,
            hitPos = ply:WorldToLocal(aim.HitPos),
            eyeAngles = ang,
            color = GAMEMODE:GetTeamColor(ply)
        }
    end
    if table.IsEmpty(onyxhud_player_info_shown) then return end


    for ply, tbl in pairs(onyxhud_player_info_shown) do
        if not IsValid(ply) then
            onyxhud_player_info_shown[ply] = nil
            continue
        end
        if tbl.TTL <= CurTime() then
            onyxhud_player_info_shown[ply] = nil
            continue
        end
        if ply:GetPos():DistToSqr(EyePos()) >= 160000 then continue end

        tbl.color.a = 255 * math.ease.OutCubic(tbl.TTL - CurTime())
        local scale = ply:GetModelScale()
        cam.Start3D2D(ply:LocalToWorld(tbl.hitPos) - EyeVector() * 10, tbl.eyeAngles, scale * 0.02)
            surface.SetFont(tag)
            surface.SetTextColor(tbl.color.r * 0.25, tbl.color.g * 0.25, tbl.color.b * 0.25, tbl.color.a)
            surface.SetTextPos(8, 8)
            surface.DrawText("Health: " .. ply:Health())
            surface.SetTextColor(tbl.color)
            surface.SetTextPos(0, 0)
            surface.DrawText("Health: " .. ply:Health())
        cam.End3D2D()
    end
end)
