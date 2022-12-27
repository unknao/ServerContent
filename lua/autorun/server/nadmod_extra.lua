hook.Add("OnEntityCreated", "pp", function(ent)
	timer.Simple(0, function() 
		if not IsValid(ent) then return end
		if not IsValid(ent:GetOwner()) then return end
		
		NADMOD.PlayerMakePropOwner(ent:GetOwner(),ent)
	end)
end)