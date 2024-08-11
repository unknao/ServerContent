AddCSLuaFile()

SWEP.PrintName = "Fake Projectile Base"
SWEP.Author = "unknao"
SWEP.Instructions = "Press Mouse1"
SWEP.Purpose = "Making non-hitscan weapons without extra entities"
SWEP.Category = "Experiments"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.ViewModel = Model( "models/weapons/cstrike/c_rif_sg552.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rif_sg552.mdl" )
SWEP.ViewModelFOV = 57
SWEP.Spawnable = true

SWEP.SwayScale = -2
SWEP.UseHands = true
--
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "Pistol"
SWEP.Primary.Recoil = -0.8

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.DrawAmmo = true
SWEP.AdminOnly = false

if SERVER then
	util.AddNetworkString("fproj_shoot")
end

local HitGroup_DmgScale = {
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
fproj = fproj or {
	PTbl = {}, --Active projectiles
	RTbl = {}, -- Registered projectile classes
}
--Registered weapon projectiles

function SWEP:Initialize()
	self:SetHoldType("ar2")
	self:RegisterProjectile("fproj_baseprimary", {})
end

local function CalculateDamageFalloff(Dist, MinDist, MaxDist, LowestPercent)
	local sollution = math.Clamp(MinDist + MaxDist - Dist, MinDist, MaxDist)
	sollution = math.Remap(sollution, MinDist, MaxDist, LowestPercent, 1)
	return sollution
end

function SWEP:RegisterProjectile(ID, Data, bOverride)
	if not bOverride and fproj.RTbl[ID] then return end
	if fproj.RTbl[ID] then print(string.format("Warning! '%s' fake projectile class was overwritten!", ID)) end

	local tbl = {
		Gravity = Data.Gravity or physenv.GetGravity() * 0.0105 * engine.TickInterval(),
		Drag = Data.Drag or 0.999, -- How much speed the projectile loses in flight at 1 - Drag value
		ForceMul = Data.ForceMul or 40,
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
			FalloffMul = CalculateDamageFalloff(ProjData.DistTravelledSqr, tbl.MinFalloffDist, tbl.MaxFalloffDist, tbl.FalloffPercent)
		end
		local ForceMul = tbl.ForceMul * FalloffMul

		Dmg:SetDamage(20 * FalloffMul)
		Dmg:ScaleDamage(HitGroup_DmgScale[tr.HitGroup])

		Dmg:SetReportedPosition(tr.HitPos)
		Dmg:SetDamagePosition(tr.HitPos)
		Dmg:SetDamageForce(tr.Normal * tbl.ForceMul)

		Dmg:SetDamageType(DMG_BULLET)

		local phys = tr.Entity:GetPhysicsObject()
		if phys and SERVER then
			phys:ApplyForceOffset(tr.Normal * ForceMul * Dmg:GetDamage() + ProjData.Vel, tr.HitPos)
		elseif tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
			tr.Entity:SetVelocity(tr.Normal * ForceMul * Dmg:GetDamage() * 1000 + ProjData.Vel)
		end

		Wep:DoImpactEffect(tr, DMG_BULLET)

		tr.Entity:DispatchTraceAttack(Dmg, tr)
	end

	fproj.RTbl[ID] = tbl
end


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:GetRecoilCompensatedNormal()
	local owner = self:GetOwner()
	local normal = owner:EyeAngles()
	normal:RotateAroundAxis(owner:EyeAngles():Right(), -owner:GetViewPunchAngles()[1])
	return normal
end

function SWEP:CreateProjectile(BulletData)
	if not IsFirstTimePredicted() then return end

	BulletData.DistTravelledSqr = 0
	fproj.PTbl[self] = fproj.PTbl[self] or {}
	local index = table.insert(fproj.PTbl[self], BulletData)
	if SERVER then
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		rf:RemovePlayer(self:GetOwner())
		net.Start("fproj_shoot")
		net.WriteEntity(self)
		net.WriteTable(BulletData)
		net.WriteVector(self:GetAttachment(2).Pos)
		net.Send(rf)
		return
	end

	PrintTable(self:GetAttachments())
	local ef = EffectData()
	ef:SetEntity(self)
	ef:SetStart(self:GetOwner():GetViewModel():GetAttachment(1).Pos)
	ef:SetMaterialIndex(index)
	util.Effect(fproj.RTbl[BulletData.ID].Effect, ef, true, true)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end

	local owner = self:GetOwner()
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + ((self:Clip1() == 0) and 0.5 or 0.09))
	owner:ViewPunch(Angle(self.Primary.Recoil, 0, 0))

	self:ShootEffects()
	self:EmitSound("weapons/fiveseven/fiveseven-1.wav", 100, math.random(120, 130), 0.8, CHAN_STATIC)
	self:EmitSound("^weapons/aug/aug-1.wav", 90, math.random(150, 160), 0.6, CHAN_STATIC)

	local normal = self:GetRecoilCompensatedNormal()
	local VecRandom = Vector(
		util.SharedRandom("fproj_base_x", -0.017, 0.017),
		util.SharedRandom("fproj_base_y", -0.017, 0.017),
		util.SharedRandom("fproj_base_z", -0.017, 0.017)
	)

	self:CreateProjectile({
		ID = "fproj_baseprimary",
		Pos = owner:EyePos(),
		Vel = (normal:Forward() + VecRandom) * 15000 * engine.TickInterval()
	})
end

function SWEP:SecondaryAttack() end

function SWEP:DoImpactEffect(tr, dmgNum)
	if not IsFirstTimePredicted() then return end

	local ef = EffectData()
	ef:SetEntity(tr.Entity)
	ef:SetStart(tr.StartPos)
	ef:SetOrigin(tr.HitPos)
	ef:SetSurfaceProp(tr.SurfaceProps)
	ef:SetDamageType(dmgNum)
	ef:SetHitBox(tr.HitGroup)
	util.Effect("Impact", ef)
end

hook.Add("Tick", "base_fproj_timestep", function()
	for Wep, ActiveProjectile in pairs(fproj.PTbl) do
		--If the weapon stops existing, bail
		if not IsValid(Wep) then
			fproj.PTbl[Wep] = nil
			continue
		end
		for I,  Proj in ipairs(ActiveProjectile) do
			--If the weapon stops existing, break this loop
			local ID = Proj.ID
			if not IsValid(Wep) then
				Proj.Vel = nil
				fproj.PTbl[Wep] = nil
				break
			end
			local tr = util.TraceLine({
				start = Proj.Pos,
				endpos = Proj.Pos + Proj.Vel,
				filter = Wep:GetOwner()
			})
			Proj.DistTravelledSqr = Proj.DistTravelledSqr + Proj.Vel:LengthSqr()

			if tr.Hit then --Do the damage, kill the table entry
				fproj.RTbl[ID].OnImpact(Wep, Wep:GetOwner(), tr, Proj)
				Proj.Vel = nil
				table.remove(fproj.PTbl[Wep], I)
			else --Keep iterating
				Proj.Vel = Proj.Vel * fproj.RTbl[ID].Drag + fproj.RTbl[ID].Gravity
				Proj.Pos = tr.HitPos
			end
		end
	end
end)

if SERVER then return end

net.Receive("fproj_shoot", function()
	local ent = net.ReadEntity()
	local tbl = net.ReadTable()
	local start = net.ReadVector()
	fproj.PTbl[ent] = fproj.PTbl[ent] or {}
	local index = table.insert(fproj.PTbl[ent], tbl)

	local ef = EffectData()
	ef:SetEntity(ent)
	ef:SetMaterialIndex(index)
	ef:SetStart(start)
	util.Effect(fproj.RTbl[tbl.ID].Effect, ef)
end)