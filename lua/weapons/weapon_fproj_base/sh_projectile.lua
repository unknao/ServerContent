FPROJ = FPROJ or { --Constants
	active_projectiles = {}, --Active projectiles
	registered_projectiles = {}, -- Registered projectile classes
	hitgroup_damage_scale = { --Default hitgroup damage scaling
		[0] = 1,
		[1] = 3,
		[2] = 1,
		[3] = 1,
		[4] = 0.6,
		[5] = 0.6,
		[6] = 0.8,
		[7] = 0.8,
		[10] = 0.01,
	}
}
FPROJ_LIB = FPROJ_LIB or {} --Library

function FPROJ_LIB.CalculateDamageFalloff(Dist, MinDist, MaxDist, LowestPercent)
	local sollution = math.Clamp(MinDist + MaxDist - Dist, MinDist, MaxDist)
	sollution = math.Remap(sollution, MinDist, MaxDist, LowestPercent, 1)
	return sollution
end

function FPROJ_LIB.RegisterProjectile(ID, Data, bOverride)
	if not bOverride and FPROJ.registered_projectiles[ID] then return end
	if FPROJ.registered_projectiles[ID] then print(string.format("Warning! '%s' fake projectile class was overwritten!", ID)) end

	local tbl = {
		Gravity = Data.Gravity or physenv.GetGravity() * 0.0105 * engine.TickInterval(),
		Drag = Data.Drag or 0.999, -- How much velocity it keeps after each timestep (ranging from 0 to 1)
		ForceMul = Data.ForceMul or 100, --How much force will it impart on physics entities
		Effect = Data.Effect or "fproj_baseprimary",
		MinFalloffDist = Data.MinFalloffDist or 600, --Range at which the bullet begins damage falloff
		MaxFalloffDist = Data.MaxFalloffDist or 900, --Range at which the bullet is at max damage falloff
		FalloffPercent = Data.FalloffPercent or 0.3, --How low the damage falloff can get between 0 and 1
	}
	tbl.MinFalloffDist = tbl.MinFalloffDist ^ 2
	tbl.MaxFalloffDist = tbl.MaxFalloffDist ^ 2

	tbl.OnImpact = Data.OnImpact or function(Wep, Ply, tr, ProjData)
		local Dmg = DamageInfo()
		Dmg:SetAttacker(Ply)
		Dmg:SetInflictor(Wep)
		local FalloffMul = 1
		if tbl.MinFalloffDist > 0 or tbl.MaxFalloffDist > 0 then
			FalloffMul = FPROJ_LIB.CalculateDamageFalloff(ProjData.DistTravelledSqr, tbl.MinFalloffDist, tbl.MaxFalloffDist, tbl.FalloffPercent)
		end
		local ForceMul = tbl.ForceMul * FalloffMul

		Dmg:SetDamage(20 * FalloffMul)
		Dmg:ScaleDamage(FPROJ.hitgroup_damage_scale[tr.HitGroup])

		Dmg:SetReportedPosition(tr.HitPos)
		Dmg:SetDamagePosition(tr.HitPos)
		Dmg:SetDamageForce(tr.Normal * tbl.ForceMul)

		Dmg:SetDamageType(DMG_BULLET)

		local phys = tr.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:ApplyForceOffset(tr.Normal * ForceMul * Dmg:GetDamage() + ProjData.Vel, tr.HitPos)
		elseif tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
			tr.Entity:SetVelocity(tr.Normal * ForceMul * Dmg:GetDamage() * 40000 + ProjData.Vel)
		end

		Wep:DoImpactEffect(tr, DMG_BULLET)
		if CLIENT then return end

		tr.Entity:TakeDamageInfo(Dmg)
	end

	FPROJ.registered_projectiles[ID] = tbl
end

hook.Add("Tick", "weapon_fproj_base_timestep", function()
	for Wep, ActiveProjectile in pairs(FPROJ.active_projectiles) do
		--If the weapon stops existing, bail
		if not IsValid(Wep) then
			FPROJ.active_projectiles[Wep] = nil
			continue
		end
		for I,  Proj in ipairs(ActiveProjectile) do
			--If the weapon stops existing, break this loop
			local ID = Proj.ID
			if not IsValid(Wep) then
				FPROJ.active_projectiles[Wep] = nil
				break
			end
			local tr = util.TraceLine({
				start = Proj.Pos,
				endpos = Proj.Pos + Proj.Vel,
				filter = Wep:GetOwner()
			})
			Proj.DistTravelledSqr = Proj.DistTravelledSqr + Proj.Vel:LengthSqr()

			if tr.Hit then --Do the damage, kill the table entry
				FPROJ.registered_projectiles[ID].OnImpact(Wep, Wep:GetOwner(), tr, Proj)
				Proj.Pos = tr.HitPos
				Proj.Vel = nil
				table.remove(FPROJ.active_projectiles[Wep], I)
			else --Keep iterating
				Proj.Vel = Proj.Vel * FPROJ.registered_projectiles[ID].Drag + FPROJ.registered_projectiles[ID].Gravity
				Proj.Pos = tr.HitPos
			end
		end
	end
end)