AddCSLuaFile()
SWEP.PrintName="ball"
SWEP.Author="John Weapon"
SWEP.Purpose="ball"
SWEP.Slot=2
SWEP.SlotPos=2
SWEP.Category="�"
SWEP.Spawnable=true

SWEP.ViewModel=Model("models/weapons/c_pistol.mdl")
SWEP.WorldModel=Model("models/weapons/w_pistol.mdl")
SWEP.ViewModelFOV=68
SWEP.UseHands=true

SWEP.Primary.ClipSize=-1
SWEP.Primary.DefaultClip=-1
SWEP.Primary.Automatic=true
SWEP.Primary.Ammo="none"

SWEP.Secondary.ClipSize=-1
SWEP.Secondary.DefaultClip=-1
SWEP.Secondary.Automatic=true
SWEP.Secondary.Ammo="none"

SWEP.DrawAmmo=true
SWEP.AdminOnly=true

local snd=Sound("HEGrenade.Bounce")
function SWEP:Initialize()
	self:SetHoldType("pistol")
end
function SWEP:Reload()
end
local function shootfx(self)
	self:EmitSound(snd)
	self:ShootEffects(self)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:SetNextPrimaryFire(CurTime(), 0.02)
	self:SetNextSecondaryFire(CurTime()+.75)
end
local function spawn(self, spd, spread)
	local bl = ents.Create("prop_combine_ball")
	bl:SetOwner(self:GetOwner())
	bl:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector()*50)

	bl:SetSaveValue("m_flRadius",10)
	bl:Activate()
	bl:Spawn()
	bl:SetSaveValue("m_nState", 3)
	local phys = bl:GetPhysicsObject()
	if not IsValid(phys) then
		bl:Remove()
		return
	end

	phys:AddGameFlag( FVPHYSICS_WAS_THROWN )
	phys:SetVelocity((self:GetOwner():GetAimVector() + VectorRand(-spread, spread)):GetNormalized() * spd )
end

function SWEP:PrimaryAttack()
	shootfx(self)
	if SERVER then
		spawn(self, 300, 0.05)
	end
end

function SWEP:SecondaryAttack()
	shootfx(self)
	if SERVER then
		spawn(self, 3000, 0)
	end
end

function SWEP:ShouldDropOnDie()
	return true
end
