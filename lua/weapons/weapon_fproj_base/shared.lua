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
SWEP.AutomaticFrameAdvance = true

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.DrawAmmo = true
SWEP.AdminOnly = false

function SWEP:Initialize()
	FPROJ_LIB.RegisterProjectile("fproj_baseprimary", {})
	self:SetHoldType("ar2")
	self:AddEffects(EF_FOLLOWBONE)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 1)

	if not SERVER then return end
	local bone_id = self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand")
	if not bone_id then return end

	self:SetMoveType(MOVETYPE_NONE)
	self:SetParent(self:GetOwner(), bone_id)
	self:SetLocalPos(Vector(12.5, -1, -12))
	self:SetLocalAngles(Angle(0, 0, 180))
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
		net.WriteVector(self:GetAttachment(1).Pos)
		if self:GetOwner():IsPlayer() then --Send to everyone except the weapon owner
			local rf = RecipientFilter()
			rf:AddAllPlayers()
			rf:RemovePlayer(self:GetOwner())
			net.Send(rf)
		else
			net.Broadcast()
		end
		return
	end

	local ef = EffectData()
	ef:SetEntity(self)
	ef:SetMaterialIndex(index)
	util.Effect(FPROJ.registered_projectiles[BulletData.ID].Effect, ef, true, true)
end

sound.Add({
	name = "fproj_base_shoot1",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = {120, 130},
	sound = ")weapons/fiveseven/fiveseven-1.wav"
})
sound.Add({
	name = "fproj_base_shoot2",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 100,
	pitch = {150, 160},
	sound = ")weapons/aug/aug-1.wav"
})

local random_spread = Vector(0, 0, 0)
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + 0.09)
	--self:GetOwner():ViewPunch(Angle(self.Primary.Recoil, 0, 0))
	self:ShootEffects()

	self:EmitSound("fproj_base_shoot1")
	self:EmitSound("fproj_base_shoot2")
	--print(SNDLVL_GUNFIRE)

	random_spread:SetUnpacked(
		util.SharedRandom("fproj_base_x", -0.005, 0.005),
		util.SharedRandom("fproj_base_y", -0.005, 0.005),
		util.SharedRandom("fproj_base_z", -0.005, 0.005)
	)
	local pos
	if CLIENT and not self:GetOwner():ShouldDrawLocalPlayer() then
		pos = self:GetOwner():GetViewModel():GetAttachment(1).Pos
	else
		pos = self:GetAttachment(1).Pos
	end


	local aim_vector = self:GetOwner():GetEyeTrace().HitPos - pos
	aim_vector:Normalize()
	self:CreateProjectile({
		ID = "fproj_baseprimary",
		Pos = pos,
		Vel = (aim_vector + random_spread) * 15000 * engine.TickInterval()
	})
	if not IsFirstTimePredicted() then return end
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

