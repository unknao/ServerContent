
hook.Add("PlayerCanHearPlayersVoice","bquiet", function(ply1,ply2)
	return ply1:GetPos():Distance(ply2:GetPos())<200
end)

hook.Add("CanTool","nocando",function(ply,tr,tool) 
	if tool == "duplicator" then
		ply:ChatPrint("no public dupes allowed")
		return false
	end
end)

hook.Add("PlayerSpawn","weapons",function(ply)
	ply:Give("none",false)
end)

hook.Add( "WeaponEquip", "Restock", function(wep,ply)
	timer.Simple(0,function() 
		ply:GiveAmmo(10000,wep:GetPrimaryAmmoType(),true) 
		ply:GiveAmmo(10000,wep:GetSecondaryAmmoType(),true) 
	end)
end)