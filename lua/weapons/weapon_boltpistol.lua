AddCSLuaFile()

SWEP.PrintName = "Bolt Pistol"
SWEP.Author = "John Projectile"
SWEP.Instructions = "Press Mouse1"
SWEP.Contact = "Carrier pigeon"
SWEP.Purpose = "Shoots"
SWEP.Category="�"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/cstrike/c_pist_fiveseven.mdl")
SWEP.WorldModel = Model("models/weapons/w_pist_fiveseven.mdl")
SWEP.ViewModelFOV = 68
SWEP.UseHands = true

SWEP.Primary.ClipSize = 15
SWEP.Primary.DefaultClip = 15
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.CSMuzzleFlashes = true
SWEP.Primary.Sound = Sound("Weapon_FiveSeven.Single")

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = true
SWEP.AdminOnly = false

local MaxSpread = 0.02
local MaxSway = 0.2
local BoltTrailColor = Color(255,163,0)

function SWEP:Initialize()
	self:SetHoldType("pistol")
end

function SWEP:PrimaryAttack()
	if self:Clip1() < 1 then self:Reload() return end
	local Owner = self:GetOwner()

	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+0.1)
	self:EmitSound(self.Primary.Sound)
	Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	if Owner:IsPlayer() then
		local vp_angle = Angle(-1.5, math.random(-MaxSway, MaxSway),0)

		Owner:ViewPunch(vp_angle)
		Owner:SetEyeAngles(Owner:EyeAngles() + vp_angle * 0.15)
	end

	if self:Clip1()<1 then self:Reload() end
	if (CLIENT) then return end

	local crossbow_bolt = ents.Create("crossbow_bolt")
	if not IsValid(crossbow_bolt) then return end

	local MuzzlePos = Owner:GetAttachment(Owner:LookupAttachment("anim_attachment_RH")).Pos
	local HitPos = self:GetOwner():GetEyeTrace().HitPos
	debugoverlay.Line(MuzzlePos, HitPos, 3)
	local AimAngle = (MuzzlePos - HitPos):Angle()

	local rand = math.Rand(-MaxSpread, MaxSpread)
	local rand_sin = math.Rand(-math.pi, math.pi)
	local Spread = LocalToWorld(Vector(0, math.sin(rand_sin) * rand, math.cos(rand_sin) * rand), angle_zero, vector_origin, AimAngle)
	local Vel = ((HitPos - MuzzlePos):GetNormalized() + Spread):GetNormalized()

	util.SpriteTrail(crossbow_bolt, 0, BoltTrailColor, false, 1, 0, 0.5, 0.5, "trails/plasma")
	crossbow_bolt:SetOwner(Owner)
	crossbow_bolt:SetPos(MuzzlePos)
	crossbow_bolt:SetAngles(Vel:Angle())
	crossbow_bolt:SetVelocity(Vel * 5000)
	crossbow_bolt:Input("SetDamage", nil, nil, 20)
	PrintTable(crossbow_bolt:GetKeyValues())
	if not crossbow_bolt:IsInWorld() then crossbow_bolt:Remove() return end

	crossbow_bolt:Spawn()
	crossbow_bolt:Activate()
end

function SWEP:SecondaryAttack() return end

function SWEP:ShouldDropOnDie()
	return true
end
