local Entity = FindMetaTable("Entity")
local Player = FindMetaTable("Player")
local Effect = FindMetaTable("CEffectData")

--alias
Entity.Wake = Entity.PhysWake
Entity.GPO = Entity.GetPhysicsObject

Player.cmd, Player.Cmd, Player.CMD = Player.ConCommand, Player.ConCommand, Player.ConCommand
RCC = RunConsoleCommand

--functions
function Entity:Sleep()
	local phys = self:GPO()
	if ( !IsValid( phys ) ) then return end
	phys:Sleep()
end

function Entity:SetMass(num)
	local phys = self:GPO()
	if ( !IsValid( phys ) ) then return end
	phys:SetMass(num)
end

function Entity:GetMass()
	local phys = self:GPO()
	if ( !IsValid( phys ) ) then return end
	return phys:GetMass()
end

function Effect:GetTable()
	local tbl = {
		["Entity"] = self:GetEntity(),
		["Attachment"] = self:GetAttachment(),
		["Origin"] = self:GetOrigin(),
		["Start"] = self:GetStart(),
		["Angle"] = self:GetAngles(),
		["Normal"] = self:GetNormal(),
		["Color"] = self:GetColor(),
		["DamageType"] = self:GetDamageType(),
		["GetFlags"] = self:GetFlags(),
		["HitBox"] = self:GetHitBox(),
		["Magnitude"] = self:GetMagnitude(),
		["Radius"] = self:GetRadius(),
		["Scale"] = self:GetScale(),
		["MaterialIndex"] = self:GetMaterialIndex(),
		["SurfaceProp"] = self:GetSurfaceProp()
	}
	return tbl
end
	