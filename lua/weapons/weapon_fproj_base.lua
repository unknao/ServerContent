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
SWEP.Primary.Recoil = -2

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
	[2] = 0.9,
	[3] = 1,
	[4] = 0.6,
	[5] = 0.6,
	[6] = 0.8,
	[7] = 0.8,
	[10] = 0.01,
}
fproj = fproj or {
	ProjectileTable = {}
}

function SWEP:Initialize()
	self:SetHoldType("ar2")
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:RecoilCompensatedDir()
	local owner = self:GetOwner()
	local normal = owner:EyeAngles()
	normal:RotateAroundAxis(owner:EyeAngles():Right(), -owner:GetViewPunchAngles()[1])
	return normal
end

function SWEP:CreateProjectile(ID, tbl)
	local owner = self:GetOwner()
	local normal = self:RecoilCompensatedDir()
	local VecRandom = Vector(util.SharedRandom("fproj_base_x", -0.017, 0.017), util.SharedRandom("fproj_base_y", -0.017, 0.017), util.SharedRandom("fproj_base_z", -0.017, 0.017))
	local tData = {
		Pos = tbl.Pos or owner:EyePos(),
		Vel = tbl.Vel or (normal:Forward() + VecRandom) * 15000 * engine.TickInterval(),
		Gravity = tbl.Gravity or physenv.GetGravity() * 0.01 * engine.TickInterval(),
		Drag = tbl.Drag or 0.999,
		Dmg = tbl.Dmg or DamageInfo(),
		ForceMul = tbl.ForceMul or 40,
		Effect = tbl.Effect or "fproj_basebullet",
	}
	fproj.ProjectileTable[self] = fproj.ProjectileTable[self] or {}
	table.insert(fproj.ProjectileTable[self], tData)
	local ef = EffectData()

	ef:SetEntity(self)
	util.Effect(tData.Effect, ef, true, true)
end

function SWEP:PrimaryAttack()
	if self:Clip1() < 1 then
		self:Reload()
		return
	end

	local owner = self:GetOwner()
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + ((self:Clip1() == 0) and 0.5 or 0.11))
	owner:ViewPunch(Angle(self.Primary.Recoil, 0, 0))

	self:ShootEffects()
	self:EmitSound("weapons/fiveseven/fiveseven-1.wav", 100, math.random(120, 130), 0.8, CHAN_STATIC)
	self:EmitSound("^weapons/aug/aug-1.wav", 90, math.random(150, 160), 0.6, CHAN_STATIC)

	if not IsFirstTimePredicted() then return end
	local dmg = DamageInfo()
	dmg:SetDamage(20)
	dmg:SetAttacker(owner)
	dmg:SetInflictor(self)
	dmg:SetDamageType(DMG_BULLET)
	self:CreateProjectile("TestProjectile",{
		Dmg = dmg
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
	for k, v in pairs(fproj.ProjectileTable) do
		if not IsValid(k) then
			fproj.ProjectileTable[k] = nil
			continue
		end
		for kk,  Proj in ipairs(v) do
			if not IsValid(k) then
				fproj.ProjectileTable[k] = nil
				break
			end
			local tr = util.TraceLine({
				start = Proj.Pos,
				endpos = Proj.Pos + Proj.Vel,
				filter = k:GetOwner()
			})
			if tr.Hit then
				if SERVER then
					Proj.Dmg:SetReportedPosition(tr.HitPos)
					Proj.Dmg:SetDamagePosition(tr.HitPos)
					Proj.Dmg:ScaleDamage(HitGroup_DmgScale[tr.HitGroup])
					Proj.Dmg:SetDamageForce(tr.Normal * Proj.ForceMul)
					local phys = tr.Entity:GetPhysicsObject()
					if phys then
						phys:ApplyForceOffset(tr.Normal * Proj.ForceMul * Proj.Dmg:GetDamage() + Proj.Vel, tr.HitPos)
					elseif tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
						tr.Entity:SetVelocity(tr.Normal * Proj.ForceMul * Proj.Dmg:GetDamage() * 1000 + Proj.Vel)
					end
					k:DoImpactEffect(tr, Proj.Dmg:GetDamageType(), false, true)
					tr.Entity:TakeDamageInfo(Proj.Dmg)
				end
				Proj.Vel = nil
				table.remove(fproj.ProjectileTable[k], kk)
			else
				Proj.Vel = Proj.Vel * Proj.Drag + Proj.Gravity
				Proj.Pos = tr.HitPos
			end
		end
	end
end)