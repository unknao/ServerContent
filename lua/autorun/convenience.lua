local Entity = FindMetaTable("Entity")
local Player = FindMetaTable("Player")

--alias
Entity.Wake = Entity.PhysWake
Entity.GPO = Entity.GetPhysicsObject

--does anyone even care?
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