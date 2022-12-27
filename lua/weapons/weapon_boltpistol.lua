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
SWEP.CSMuzzleFlashes=true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = true
SWEP.AdminOnly = false

function SWEP:Initialize()
	
	self:SetHoldType( "pistol" )
	
end

function SWEP:Reload()
	if (!self:HasAmmo() ) then return end
	self:DefaultReload(ACT_VM_RELOAD)
end

local cb={ShootSound=Sound("weapons/fiveseven/fiveseven-1.wav"),
	sway=0.2
	}


function SWEP:PrimaryAttack()
	if self:Clip1()<1 then self:Reload() return end
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime()+0.1)
	self:EmitSound(cb.ShootSound)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if self.Owner.ViewPunch then
		self.Owner:ViewPunch(Angle(math.random(-cb.sway,cb.sway),math.random(-cb.sway,cb.sway),0))
	end
	if (CLIENT) then return end
		cb.pos=self.Owner:GetBonePosition(12)
		cb.shootpos=cb.pos+self:GetUp()*3+self:GetForward()*8.5
		cb.spread=self:GetUp()*math.random(-20,20)+self:GetRight()*math.random(-20,20)
		cb.ent = ents.Create("crossbow_bolt")
		if (!IsValid(cb.ent)) then return end
		util.SpriteTrail(cb.ent,0,Color(255,163,0), false,1,0,0.5,0.5, "trails/plasma" )
		cb.ent:SetColor(Color(0,0,0,255))
		cb.ent:SetOwner(self.Owner)
		cb.ent:SetPos(cb.shootpos)
		cb.ent:SetAngles((cb.shootpos-self.Owner:GetEyeTrace().HitPos):Angle())
		cb.ent:SetVelocity(((self.Owner:GetEyeTrace().HitPos-cb.shootpos):GetNormalized()*5000)+cb.spread)
		if not cb.ent:IsInWorld() then cb.ent:Remove() return end
		cb.ent.isboltpistolbolt=true
		cb.ent:Spawn()
end

hook.Add("EntityTakeDamage", "boltpistoldmg", function(ent,dmg)
	local inf = dmg:GetInflictor()
	if IsValid(inf) and inf.isboltpistolbolt then
		dmg:SetDamagePosition(inf:GetPos())
		dmg:SetReportedPosition(inf:GetPos())
		dmg:SetDamageType(DMG_BULLET)
		dmg:SetDamageBonus(20)
		dmg:SetDamage(20)
	end
end)

function SWEP:SecondaryAttack() return end

function SWEP:ShouldDropOnDie()
	return true
end
