hook.Add("PlayerDeathSound","nobeep",function() return true end)
hook.Add("DoPlayerDeath","lastwep",function(ply)
	ply.lastwep=ply:GetActiveWeapon():GetClass()
end)
hook.Add("PlayerSpawn","lastwep",function(ply)
	timer.Simple(0,function()
		if not ply.lastwep then return end
		ply:SelectWeapon(ply.lastwep)
		ply.lastwep=nil 
	end)
end)
