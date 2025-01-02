local tag = "PlayerDeathSounds"

hook.Add("PlayerDeathSound",tag,function(ply)
	ply:SetDSP(26)
	if timer.Exists("ExplosionMuffle_" .. tostring(ply:EntIndex())) then
		timer.Remove("ExplosionMuffle_" .. tostring(ply:EntIndex()))
	end

	return true
end)

hook.Add("PlayerSpawn", tag, function(ply)
	ply:SetDSP(1)
end)

hook.Add("OnDamagedByExplosion", tag, function(ply, dmg)
	ply:SetDSP(34)
	timer.Create("ExplosionMuffle_" .. tostring(ply:EntIndex()), dmg:GetDamage() * 0.01, 1, function()
		print("s")
		ply:SetDSP(ply:Alive() and 1 or 26)
	end)
	return true
end)