local tag="nametags"

NAMETAG_HIDE = CreateConVar("nametags_hide", "0", {FCVAR_ARCHIVE}, "Hide custom nametags.")
RSCHAT_HIDE = CreateConVar("rschat_hide", "0", {FCVAR_ARCHIVE}, "Hide RuneScape style overhead chat.")

surface.CreateFont(tag, {
	font = "Courier New",
	size = 200,
	weight = 1200,
	extended = true,
} )
surface.CreateFont("rschat", {
	font = "RuneScape Bold 12",
	size = 130,
	weight = 12,
	extended = true,
} )
-- runescape styled chat
hook.Add("OnPlayerChat", "rs_chat", function(ply, text, is_team)
	if is_team then return end
	ply.rschat = text
	ply.rschat_lifetime = CurTime() + 3
end)
	
--dont forget to make it readable next time
hook.Add("PostDrawTranslucentRenderables",tag,function() 
	if NAMETAG_HIDE:GetBool() and RSCHAT_HIDE:GetBool() then return end
	for k,v in ipairs(player.GetAll()) do
	
		if v:IsDormant() then continue end
		if v == LocalPlayer() and !v:ShouldDrawLocalPlayer() then continue end
		
		local ply_or_ragdoll = v:GetRagdollEntity() == NULL and v or v:GetRagdollEntity()
		
        local head_attach = ply_or_ragdoll:LookupBone("ValveBiped.Bip01_Head1")
        if not head_attach then continue end
		
        local head,_ = ply_or_ragdoll:GetBonePosition(head_attach)
		
        if head == ply_or_ragdoll:GetPos() then
            head = ply_or_ragdoll:GetBoneMatrix(head_attach)
        end
		
		local scale = v:GetModelScale() --take size into account
		local head_up=ply_or_ragdoll:GetUp()
        local pos = head + head_up * 20 * scale
		local rschat_pos = head + head_up * 25 * scale
		local dist = EyePos():Distance(pos)
		if dist >= 400 * scale then continue end
		local ang = EyeAngles()

		--necessary evil?
		ang:RotateAroundAxis( ang:Up(), -90 )
		ang:RotateAroundAxis( ang:Forward(), 90 )
		
		--nametags
		if not NAMETAG_HIDE:GetBool() then
			cam.Start3D2D(pos,ang, 0.03 * scale)
				local text = v:Name()
				local namecolor = GAMEMODE:GetTeamColor(v)
				local nameshadow = Color(namecolor.r / 4, namecolor.g / 4, namecolor.b / 4)
				local themnorm = (pos - EyePos()):GetNormalized()
				
				local distalpha= 255 - math.Clamp(-1650 + dist * (5 / scale), 0, 255) --woo magic numbers
				local diralpha = v == LocalPlayer() and 255 or math.Clamp(2000 - (1 - EyeVector():Dot(themnorm)) * (dist * (300 / scale)), 0, 255)
				
				namecolor.a, nameshadow.a = math.min(distalpha, diralpha), math.min(distalpha, diralpha)
				
				draw.SimpleText(text, tag, 8, 8, nameshadow, TEXT_ALIGN_CENTER)
				draw.SimpleText(text, tag, 0, 0,namecolor,TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
		
		--rschat
		if not RSCHAT_HIDE:GetBool() then
			cam.Start3D2D(rschat_pos, ang, 0.03 * scale)
				local themnorm = (pos - EyePos()):GetNormalized()
				local distalpha= 255 - math.Clamp(-1650 + dist * (5 / scale), 0, 255)
				
				local diralpha = v == LocalPlayer() and 255 or math.Clamp(2000 - (1 - EyeVector():Dot(themnorm)) * (dist * (300 / scale)), 0, 255)
								
				if v.rschat and v.rschat_lifetime and v.rschat_lifetime > CurTime() then
					draw.SimpleText(v.rschat, "rschat", 6, 6 ,Color(25, 25, 0, math.min(distalpha, diralpha)),TEXT_ALIGN_CENTER)
					draw.SimpleText(v.rschat, "rschat", 0, 0,Color(255, 255, 0, math.min(distalpha, diralpha)),TEXT_ALIGN_CENTER)
				end
			cam.End3D2D()
		end
	end
end)