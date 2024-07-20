AddCSLuaFile()

SWEP.PrintName = "Grenade Shotgun"

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.Category="�"

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/cstrike/c_shot_xm1014.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_shot_xm1014.mdl" )
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.AdminOnly = true
function SWEP:Initialize()
	self:SetHoldType("shotgun")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:EmitSound(Sound("weapons/widow_maker_shot_0"..math.random(1,3)..".wav"))
	if CLIENT then return end

	for i=1,30 do
		local frag = ents.Create("npc_grenade_frag")
		if(!IsValid(frag)) then return end

		frag:SetColor(HSVToColor(i*12,1,1))
		frag:SetMaterial("models/debug/debugwhite",true)
		frag:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		frag:SetPos(self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) )
		frag:SetAngles(self.Owner:EyeAngles()+Angle(90,0,0))
		frag:SetOwner(self.Owner)
		frag:Spawn()
		local phys = frag:GetPhysicsObject()
		if ( !IsValid( phys ) ) then frag:Remove() return end
		local velocity = self.Owner:GetAimVector()
		velocity = velocity * 2000
		velocity = velocity + ( VectorRand() * 300 )
		phys:ApplyForceCenter( velocity )
		frag:Fire("SetTimer",0,1)
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime()+0.05)
	self:SetNextPrimaryFire( CurTime() + 0.05 )
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:EmitSound(Sound("weapons/tf_spy_enforcer_revolver_0"..math.random(1,6)..".wav"))
	if CLIENT then return end

	local rocket = ents.Create("rpg_missile")
	if(!IsValid(rocket)) then return end

	rocket:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	rocket:SetPos(self.Owner:EyePos())
	rocket:SetAngles( self.Owner:EyeAngles() + AngleRand(-3, 3))
	rocket:SetVelocity((self:GetOwner():GetAimVector() + VectorRand(-0.05, 0.05)) * 500 + Vector(0, 0, 100))
	rocket:SetOwner(self.Owner)
	rocket:SetSaveValue( "m_flDamage", 100 )
	rocket:Spawn()
	rocket:Activate()

end

function SWEP:ShouldDropOnDie()

	return false

end