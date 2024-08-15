SWEP.PrintName = "crash gun"
SWEP.Author = "john thisweapon"
SWEP.Purpose = "deletes retards"
SWEP.Category="�"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel = Model( "models/weapons/c_smg1.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_smg1.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false

if CLIENT then
	CreateMaterial("weapon_crashgun_sheet", "VertexLitGeneric",{
		["$basetexture"] = "models/props_lab/warp_sheet",
		["$model"] = 1,
		["$color2"] = "[0.317647 0.239216 0.4]",
		["Proxies"] = {
			["TextureScroll"] = {
				["texturescrollvar"] = "$basetexturetransform",
				["texturescrollrate"] = 0.5,
				["texturescrollangle"] = 90
			}
		}
	})
	--crashgun_sheet:SetVector("$color2", Vector(0.317647, 0.239216, 0.4))
end

function SWEP:Initialize()
	self:SetHoldType("smg")
end

function SWEP:DrawWorldModel()
	self:SetMaterial("!weapon_crashgun_sheet")
	self:DrawModel()
end

function SWEP:PreDrawViewModel(vm, wep, ply)
	vm:SetSubMaterial(1, "!weapon_crashgun_sheet")
end

function SWEP:Reload() end
function SWEP:ShouldDropOnDie() return false end

WEAPON_CRASHGUN_PROJECTILES = WEAPON_CRASHGUN_PROJECTILES or {}


function SWEP:PrimaryAttack()
	local target = self:GetOwner():GetEyeTrace().Entity
	if not IsValid(target) then return end

	self:EmitSound("vo/k_lab/ba_guh.wav")
	if CLIENT then return end

	if not self:GetOwner():IsSuperAdmin() then
		self:GetOwner():SendLua([[os.date("%")]])
		return
	end

	local ball = ents.Create("base_anim")
	ball:SetPos(self:GetOwner():GetShootPos())
	ball:Spawn()

	table.insert(WEAPON_CRASHGUN_PROJECTILES, #WEAPON_CRASHGUN_PROJECTILES + 1, {
		ent = ball,
		target = target,
		ttl = CurTime() + 200
	})
end

if CLIENT then return end

sound.Add({
	name = "weapon_crashgun_fail",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	sound = {
		"*vo/k_lab/ba_getitoff01.wav",
		"*vo/k_lab/ba_getoutofsight01.wav",
		"*vo/k_lab/ba_myshift01.wav",
		"*vo/k_lab/ba_notime.wav",
		"*vo/k_lab/ba_pissinmeoff.wav",
		"*vo/k_lab/ba_pushinit.wav",
	}
})
sound.Add({
	name = "weapon_crashgun_success",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	sound = {
		"*vo/k_lab/ba_ishehere.wav",
		"*vo/k_lab/ba_sarcastic01.wav",
		"*vo/k_lab/ba_sarcastic03.wav",
		"*vo/k_lab/ba_itsworking04.wav",
		"*vo/k_lab/ba_notimetofool01.wav",
		"*vo/k_lab/ba_whoops.wav",
		"*vo/k_lab/ba_thisway.wav",
		"*vo/k_lab/ba_thereyouare.wav",
	}
})
hook.Add("Tick","weapon_crashgun_timestep",function()
	for i, projectile in ipairs(WEAPON_CRASHGUN_PROJECTILES) do
		if not IsValid(projectile.ent) then
			table.remove(WEAPON_CRASHGUN_PROJECTILES, i)
			continue
		end
		if not IsValid(projectile.target) or projectile.ttl < CurTime() then
			projectile.ent:EmitSound("weapon_crashgun_fail")
			projectile.ent:Remove()
			table.remove(WEAPON_CRASHGUN_PROJECTILES, i)
			continue
		end

		local dist = projectile.target:GetPos():Distance(projectile.ent:GetPos())
		if dist <= 30 then
			if projectile.target:IsPlayer() then
				projectile.target:SendLua([[os.date("%")]])
				projectile.target:Kill()
			else
				projectile.target:Remove()
			end
			projectile.ent:EmitSound("weapon_crashgun_success")
			projectile.ent:Remove()
			table.remove(WEAPON_CRASHGUN_PROJECTILES, i)
		end

		local dir = projectile.target:GetPos() - projectile.ent:GetPos()
		dir:Normalize()
		local vel = projectile.target:GetVelocity():Length()
		projectile.ent:SetPos(projectile.ent:GetPos() + dir * (math.min((50 + vel * 0.9) * FrameTime(), dist)))
	end
end)