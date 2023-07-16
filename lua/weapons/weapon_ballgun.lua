AddCSLuaFile()
SWEP.PrintName="ball"
SWEP.Author="John Weapon"
SWEP.Purpose="ball"
SWEP.Slot=2
SWEP.SlotPos=2
SWEP.Category="¶"
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
	self:SetNextPrimaryFire(CurTime()+.75)
	self:SetNextSecondaryFire(CurTime()+.75)
end
local function spawn(self,spd)
	local bl=ents.Create("point_combine_ball_launcher")
	local pos = self.Owner:GetShootPos()+self.Owner:EyeAngles():Forward()
	bl:SetPos(pos)
	bl:SetOwner(self.Owner)
	bl:Spawn()
	bl:Activate()
	bl:SetKeyValue("angles",tostring(self.Owner:EyeAngles()))
	bl:SetKeyValue("ballcount","1")
	bl:SetKeyValue("maxspeed",spd)
	bl:SetKeyValue("minspeed",spd)
	bl:SetKeyValue("spawnflags","2")
	bl:SetKeyValue("launchconenoise","0")
	bl:Fire("launchBall")
	bl:Fire("kill")
	timer.Simple(0, function()
		if not IsValid(self) then return end
		if not IsValid(self.Owner) then return end
		
		for k,v in pairs(ents.FindInSphere(pos, 20)) do
			if not IsValid(v) then continue end
			if not v:GetClass() == "prop_combine_ball" then continue end
			if IsValid(v:GetOwner()) then continue end
			
			v:SetOwner(self.Owner)
			v:GetPhysicsObject():AddGameFlag( FVPHYSICS_WAS_THROWN )
		end
	end)
end

function SWEP:PrimaryAttack()
	shootfx(self)
	if SERVER then
		spawn(self,"1500")
	end
end

function SWEP:SecondaryAttack()
	shootfx(self)
	if SERVER then
		spawn(self,"300")
	end
end

function SWEP:ShouldDropOnDie()
	return true
end
