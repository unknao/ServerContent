AddCSLuaFile()

SWEP.PrintName = "Sledgehammer"
SWEP.Category="�"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl" )
SWEP.WorldModel = Model( "models/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl" )
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.AdminOnly = true
function SWEP:Initialize()
	self:SetHoldType("melee2")
end
local gh={}




function SWEP:PrimaryAttack()
	self:EmitSound("weapons/cbar_miss1.wav")
	gh.dist=self.Owner:GetEyeTrace().HitPos:Distance(self.Owner:GetEyeTrace().StartPos)
	self:SetNextPrimaryFire(CurTime()+0.5)
	gh.trace=self.Owner:GetEyeTrace().Entity
	gh.phys=gh.trace:GetPhysicsObject()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
if gh.dist<70 then
	self:EmitSound("weapons/saxxy_impact_gen_01.wav")
	if SERVER then
	local ef = EffectData()
	ef:SetOrigin(self.Owner:GetEyeTrace().HitPos)
	ef:SetScale(1)
	timer.Simple(0, function() 
	util.Effect("ElectricSpark", ef) 
	util.Effect("HL1GaussWallImpact2", ef) 
	end)
	gh.velocity = self.Owner:GetAimVector()
	constraint.RemoveAll(gh.trace)
	gh.velocity = gh.velocity * 2000*gh.phys:GetMass()
	gh.phys:ApplyForceOffset(gh.velocity,self.Owner:GetEyeTrace().HitPos)
	gh.trace:TakeDamage(100,self,self)
	end
end
end


function SWEP:ShouldDropOnDie()
	
	return false
	
end