AddCSLuaFile()

SWEP.PrintName = "A Gun"
SWEP.Author = "unknao"
SWEP.Purpose = "Threatening and mugging."

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_pistol.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_pistol.mdl" )
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
SWEP.Category = "Default"

SWEP.DrawAmmo = false
SWEP.AdminOnly = false

local weaponSelectionColor = Color( 255, 220, 0, 255 )
function SWEP:DrawWeaponSelection( x, y, w, t, a )
    weaponSelectionColor.a = a
    draw.SimpleText( "d", "pistol_icon", x + w / 2, y, weaponSelectionColor, TEXT_ALIGN_CENTER)

    self:PrintWeaponInfo(x + w + 10, y + t * 1.1, alpha)
end

function SWEP:Initialize()
	self:SetHoldType( "pistol" )
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime())

	self:EmitSound("Weapon_Pistol.Single")
	self:ShootEffects()

    local owner = self:GetOwner()
    self:FireBullets({
        Damage = 10000,
        Src = owner:GetShootPos(),
        Dir = owner:GetForward(),
        TracerName = "Tracer",
        Force = 10
    })
end

function SWEP:SecondaryAttack() end
function SWEP:ShouldDropOnDie() return false end
function SWEP:Reload() end
function SWEP:CanBePickedUpByNPCs() return false end
if SERVER then return end

surface.CreateFont("pistol_icon",{
    font = "HalfLife2",
    size = 150,
    antialias = true,
    outline = false,
    weight = 1
})