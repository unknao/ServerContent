AddCSLuaFile()
SWEP.PrintName="Manual Labor"
SWEP.Author="John Weapon"
SWEP.Purpose="damn it feels bad to be a gangster"
SWEP.Category="¶"
SWEP.Slot=2
SWEP.SlotPos=2
SWEP.Spawnable=true
SWEP.ViewModel=Model("models/weapons/cstrike/c_pist_usp.mdl")
SWEP.WorldModel=Model("models/weapons/w_pist_usp_silencer.mdl")
SWEP.ViewModelFOV=68
SWEP.UseHands=true
SWEP.Primary.ClipSize=-1
SWEP.Primary.DefaultClip=-1
SWEP.Primary.Automatic=false
SWEP.Primary.Ammo="none"
SWEP.CSMuzzleFlashes=true
SWEP.Secondary.ClipSize=-1
SWEP.Secondary.DefaultClip=-1
SWEP.Secondary.Automatic=false
SWEP.Secondary.Ammo="none"
SWEP.DrawAmmo=true
SWEP.AdminOnly=false
function SWEP:Initialize()
	self:SetHoldType("pistol")
end
function SWEP:Reload()
end
local snd=Sound("weapons/usp/usp1.wav")
function SWEP:PrimaryAttack()
	--self:SetNextPrimaryFire(CurTime()+0.2)
	self:EmitSound(snd)
	self:ShootEffects(self)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:ShootBullet(10,1,0)
	self.Owner:SetVelocity(-self.Owner:EyeAngles():Forward()*20)
	self:TakePrimaryAmmo(1)	
end
function SWEP:SecondaryAttack()
	return
end
function SWEP:ShouldDropOnDie()
	return true
end
function SWEP:Reload()
	--self:DefaultReload(ACT_VM_RELOAD)
end