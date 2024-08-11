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

function SWEP:Initialize()
	self:SetHoldType("ar2")
end

function SWEP:RegisterProjectile(ID, Data, bOverride)

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
	FPROJ.active_projectiles[self] = FPROJ.active_projectiles[self] or {}
	local index = table.insert(FPROJ.active_projectiles[self], BulletData)
	if SERVER then
		net.Start("fproj_shoot")
		net.WriteEntity(self)
		net.WriteTable(BulletData)
		net.WriteVector(BulletData.Pos + BulletData.Vel)
		if self:GetOwner():IsPlayer() then --Send to everyone except the weapon owner
			local rf = RecipientFilter()
			rf:AddAllPlayers()
			rf:RemovePlayer(self:GetOwner())
			net.Send(rf)
		else --Send to everyone except the weapon owner
			net.Broadcast()
		end
		return
	end

	local ef = EffectData()
	ef:SetEntity(self)
	ef:SetStart(BulletData.Pos + BulletData.Vel)
	ef:SetMaterialIndex(index)
	util.Effect(FPROJ.registered_projectiles[BulletData.ID].Effect, ef, true, true)
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + ((self:Clip1() == 0) and 0.5 or 0.09))
	self:GetOwner():ViewPunch(Angle(self.Primary.Recoil, 0, 0))

	self:ShootEffects()
	self:EmitSound("weapons/fiveseven/fiveseven-1.wav", 100, math.random(120, 130), 0.8, CHAN_STATIC)
	self:EmitSound("^weapons/aug/aug-1.wav", 90, math.random(150, 160), 0.6, CHAN_STATIC)

	local normal = self:GetRecoilCompensatedNormal()
	local VecRandom = Vector(
		util.SharedRandom("fproj_base_x", -0.005, 0.005),
		util.SharedRandom("fproj_base_y", -0.005, 0.005),
		util.SharedRandom("fproj_base_z", -0.005, 0.005)
	)

	self:CreateProjectile({
		ID = "fproj_baseprimary",
		Pos = self:GetOwner():ShootPos(),
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