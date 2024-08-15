function EFFECT:Init(Data)
    self:SetRenderBounds(Vector(-64, -64, -64), Vector(64, 64, 64))
    self:SetCollisionBounds(Vector(-64, -64, -64), Vector(64, 64, 64))

    self.Weapon = Data:GetEntity()
    self.index = Data:GetMaterialIndex()
    if self.Weapon:GetParent() == LocalPlayer() then
        self.Muzzle = self.Weapon:GetParent():GetViewModel():GetAttachment(1).Pos
    else
        self.Muzzle = self.Weapon:GetAttachment(1).Pos
    end

    self.tbl = FPROJ.active_projectiles[self.Weapon][self.index]
    if not self.tbl then return end

    self.pos = self.Muzzle

    self.trail_points = self.trail_points or {}
    for i = 1, 10 do
        self.trail_points[i] = self.pos
    end

end

function EFFECT:Think()
    if not IsValid(self.Weapon) then return false end
    if not IsValid(self.Weapon:GetParent()) then return false end

    for i = 10, 2, -1 do
        self.trail_points[i] = self.trail_points[i - 1]
    end
    self.pos = self.tbl.Pos or self.pos
    self.trail_points[1] = self.pos
    if not self.tbl.Vel then return self:Finish() end

    self:SetPos(self.pos)
    return true
end

function EFFECT:Finish()
    self.finishing = true
    if not self.trail_points then return false end
    if self.trail_points[#self.trail_points] == self.trail_points[1] then
        return false
    end
    return true
end

local mat = Material( "sprites/orangeflare1" )
local mat_trail = Material("sprites/physbeama")
local color_trail = Color(255, 153, 0)
function EFFECT:Render()
    if not self.pos then return end


    render.StartBeam(10)
        render.SetMaterial(mat_trail)
        for i = 10, 1, -1 do
            render.AddBeam(self.trail_points[i], 5 - i * 0.5, i * 0.5, color_trail)
        end
    render.EndBeam()
    if self.finishing then return end

    render.SetMaterial(mat)
    render.DrawQuadEasy(self.pos, -EyeVector(), 8, 8, color_white)
end