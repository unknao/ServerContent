
hook.Add("PlayerCanHearPlayersVoice","bquiet", function(ply1,ply2)
	return ply1:GetPos():Distance(ply2:GetPos())<200
end)

hook.Add("PlayerSpawn","weapons",function(ply)
	if not IsValid(ply) then return end

	ply:Give("none",false)
end)

hook.Add( "WeaponEquip", "Restock", function(wep,ply)
	if not IsValid(ply) then return end

	timer.Simple(0,function()
		ply:GiveAmmo(10000,wep:GetPrimaryAmmoType(),true)
		ply:GiveAmmo(10000,wep:GetSecondaryAmmoType(),true)
	end)
end)