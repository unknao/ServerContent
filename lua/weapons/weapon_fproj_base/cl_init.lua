include("sh_projectile.lua")
include("shared.lua")

net.Receive("fproj_shoot", function()
	local ent = net.ReadEntity()
	local tbl = net.ReadTable()
	FPROJ.active_projectiles[ent] = FPROJ.active_projectiles[ent] or {}
	local index = table.insert(FPROJ.active_projectiles[ent], tbl)

	local ef = EffectData()
	ef:SetEntity(ent)
	ef:SetMaterialIndex(index)
	util.Effect(FPROJ.registered_projectiles[tbl.ID].Effect, ef)
end)

function SWEP:DrawWorldModel()
	self:SetMaterial("models/props_lab/security_screens")
	self:DrawModel()
end

function SWEP:PreDrawViewModel(vm, wep, ply)
	vm:SetSubMaterial(1, "models/props_lab/security_screens")

end

function SWEP:ViewModelDrawn(vm)
	vm:SetSubMaterial(1, "")
end
