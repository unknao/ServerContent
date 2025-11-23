local tag = "onyxhud_nametags"
local onyxhud_nametags_enable = CreateConVar("onyxhud_nametags_enable", 1, {FCVAR_ARCHIVE}, "Controls whether the custom nametags draw or not.")
local onyxhud_playerrings_enable = CreateConVar("onyxhud_playerrings_enable", 1, {FCVAR_ARCHIVE}, "Controls whether player rings at players feet draw or not.")
local onyxhud_nametag_flags_enable = CreateConVar("onyxhud_nametag_flags_enable", 1, {FCVAR_ARCHIVE}, "Controls whether or not the country flag of the player is drawn to the right of the nametag (disabling nametags disables this also).")

--Load svg library
local SVGS = {
	superadmin = "nametags_superadmin_200",
	admin = "nametags_admin_200"
}
local requested = {}
local function RequestFlagSVG(code)
	if requested[code] then return end
	requested[code] = true

	svg.LoadURL(string.format("https://raw.githubusercontent.com/hampusborgos/country-flags/refs/heads/main/svg/%s.svg", code), "flag_" .. code, 250, 200)
end

local color_blank = Color(0, 0, 0, 0)
gameevent.Listen("player_changename")
hook.Add("player_changename", tag, function(data)
	local ply = Player(data.userid)
	ply.onyxhud_namelength = draw.SimpleText(data.newname, "onyxhud_player_info", 0, 0, color_blank)
end)

local flag_shadow = Color(64, 64, 64)
local ring_material = Material("particle/particle_ring_wave_additive")
hook.Add("PostDrawTranslucentRenderables", tag, function()

	for _, ply in player.Iterator() do
		if ply == LocalPlayer() and not ply:ShouldDrawLocalPlayer() then return end
		if ply:IsDormant() then return end

		local colors = ONYXHUD.Colors[ply:Team()]
		if onyxhud_playerrings_enable:GetBool() then --Player rings
			render.SetMaterial(ring_material)
			render.DrawQuadEasy(ply:GetPos() + vector_up, vector_up, 32, 32, colors[1], 0)
		end
		if not onyxhud_nametags_enable:GetBool() then return end --Nametags

		local ply_or_ragdoll = IsValid(ply:GetRagdollEntity()) and ply:GetRagdollEntity() or ply
		local head_attach = ply_or_ragdoll:LookupBone("ValveBiped.Bip01_Head1")
		if not head_attach then return end

		local head,_ = ply_or_ragdoll:GetBonePosition(head_attach)

		if head == ply_or_ragdoll:GetPos() then
			head = ply_or_ragdoll:GetBoneMatrix(head_attach)
		end

		local scale = ply:GetModelScale() --take size into account
		local head_up = ply_or_ragdoll:GetUp()
		local pos = head + head_up * 20 * scale
		local dist = EyePos():DistToSqr(pos)
		if dist >= 160000 * scale then return end --if further than 400 units, bail

		local ang = EyeAngles()

		--necessary evil?
		ang:RotateAroundAxis( ang:Up(), -90 )
		ang:RotateAroundAxis( ang:Forward(), 90 )

		local distalpha = 1 - math.ease.InExpo(dist / (160000 * scale))
		local ply_dir = (pos - EyePos()):GetNormalized()
		local diralpha = ply == LocalPlayer() and 1 or math.ease.OutExpo(1 - (1 - ply_dir:Dot(EyeVector())) * (0.005 * dist * (scale * 0.01)))
		local alpha_composite = math.min(distalpha, diralpha)
		if alpha_composite <= 0 then return end
		local text = ply:Name()
		if not ply.onyxhud_namelength then
			ply.onyxhud_namelength = draw.SimpleText(text, "onyxhud_player_info", 0, 0, color_blank)
		end


		surface.SetAlphaMultiplier(alpha_composite)
		cam.Start3D2D(pos,ang, 0.03 * scale)
			ONYXHUD.DrawTextShadowed(text, "onyxhud_player_info", 0, 0, colors[1], colors[2], 8, TEXT_ALIGN_CENTER)
			local rank = ply:GetUserGroup()
			if SVGS[rank] and svg.IsValid(SVGS[rank]) then
				local rankpadding = -ply.onyxhud_namelength / 2 - 220
				svg.Draw(SVGS[rank], rankpadding + 8, 8, colors[2])
				svg.Draw(SVGS[rank], rankpadding, 0, colors[1])
			end
			if onyxhud_nametag_flags_enable:GetBool() then
				local cc = string.lower(ply:nw3GetString("country_code"))
				local flag_code = "flag_" .. cc

				if svg.IsValid(flag_code) and requested[cc] then
					local flagpadding = ply.onyxhud_namelength / 2 + 30

					svg.Draw(flag_code, flagpadding + 8, 24, flag_shadow)
					svg.Draw(flag_code, flagpadding, 16)

				else
					RequestFlagSVG(cc)
				end
			end
		cam.End3D2D()
		surface.SetAlphaMultiplier(1)
	end
end)

