net.Receive("3dplay",function()
	tbl=net.ReadTable()
	sound.PlayURL(tbl[1],"3d",function(pos)
		if IsValid(pos) then
			pos:SetPos(tbl[2]:GetPos())
			pos:Play()
			tbl[2].sound=pos
		end
	end)
end)

hook.Add("Think","TTS",function()
	for k,v in pairs(player.GetAll()) do
		if IsValid(v.sound) then
			v.sound:SetPos(v:GetPos())
		end
	end
end)