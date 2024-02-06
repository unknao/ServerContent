resource.AddSingleFile("resource/fonts/Mieghommel.ttf") --Font obtained from https://online-fonts.com
if SERVER then return end

local tag = "nametags"

NAMETAG_HIDE = CreateConVar("nametags_hide", "0", {FCVAR_ARCHIVE}, "Hide custom nametags.")

surface.CreateFont(tag, {
	font = "Mieghommel",
	size = 200,
	weight = 1200,
	extended = true,
})

local broom = Material("icons8/100/clean.png")
local badge = Material("icons8/100/badge.png")
local RankMaterial = {
	superadmin = badge,
	admin = broom
}

--dont forget to make it readable next time
hook.Add("PostDrawTranslucentRenderables",tag,function()
	if NAMETAG_HIDE:GetBool() then return end
	for _, ply in ipairs(player.GetAll()) do
		if ply:IsDormant() then continue end
		if ply == LocalPlayer() and not ply:ShouldDrawLocalPlayer() then continue end

		local ply_or_ragdoll = ply:GetRagdollEntity() == NULL and ply or ply:GetRagdollEntity()
		local head_attach = ply_or_ragdoll:LookupBone("ValveBiped.Bip01_Head1")
		if not head_attach then continue end

		local head,_ = ply_or_ragdoll:GetBonePosition(head_attach)

		if head == ply_or_ragdoll:GetPos() then
			head = ply_or_ragdoll:GetBoneMatrix(head_attach)
		end

		local scale = ply:GetModelScale() --take size into account
		local head_up = ply_or_ragdoll:GetUp()
		local pos = head + head_up * 20 * scale
		local dist = EyePos():Distance(pos)
		if dist >= 400 * scale then continue end

		local ang = EyeAngles()

		--necessary evil?
		ang:RotateAroundAxis( ang:Up(), -90 )
		ang:RotateAroundAxis( ang:Forward(), 90 )

		cam.Start3D2D(pos,ang, 0.03 * scale)
			local text = ply:Name()

			local themnorm = (pos - EyePos()):GetNormalized()

			local distalpha = 255 - math.Clamp(-1650 + dist * (5 / scale), 0, 255) --woo magic numbers
			local diralpha = ply == LocalPlayer() and 255 or math.Clamp(2000 - (1 - EyeVector():Dot(themnorm)) * (dist * (100 / scale)), 0, 255)

			if not ply.Nametags then

				local cName = GAMEMODE:GetTeamColor(ply)
				local cShadow = Color(cName.r / 4, cName.g / 4, cName.b / 4)
				ply.Nametags = {
					cName = cName,
					cShadow = cShadow
				}
			end
			ply.Nametags.cName.a, ply.Nametags.cShadow.a = math.min(distalpha, diralpha), math.min(distalpha, diralpha)

			draw.SimpleText(text, tag, 8, 8, ply.Nametags.cShadow, TEXT_ALIGN_CENTER)
			draw.SimpleText(text, tag, 0, 0,ply.Nametags.cName, TEXT_ALIGN_CENTER)

			if RankMaterial[ply:GetUserGroup()] then
				surface.SetMaterial(RankMaterial[ply:GetUserGroup()])
				surface.SetFont(tag)
				local rankpadding = -surface.GetTextSize(text) / 2 - 220
				surface.SetDrawColor(ply.Nametags.cShadow)
				surface.DrawTexturedRect(rankpadding + 8, 8, 200, 200)
				surface.SetDrawColor(ply.Nametags.cName)
				surface.DrawTexturedRect(rankpadding, 0, 200, 200)
			end
		cam.End3D2D()
	end
end)