function EFFECT:Init(Data)
    self:SetRenderBounds(Vector(-64, -64, -64), Vector(64, 64, 64))
    self:SetCollisionBounds(Vector(-64, -64, -64), Vector(64, 64, 64))

    self.Weapon = Data:GetEntity()
    self.index = Data:GetMaterialIndex()
    self.start = Data:GetStart()

    self.tbl = fproj.PTbl[self.Weapon][self.index]
    if not self.tbl then return end

    self.pos = self.start
    self.vel = self.tbl.Vel

    self.trail_points = self.trail_points or {}
    for i = 1, 20 do
        self.trail_points[i] = self.start
    end

end

function EFFECT:Think()
    if not IsValid(self.Weapon) then return false end
    if not IsValid(self.Weapon:GetParent()) then return false end
    if not self.tbl then return self:Finish() end
    if not self.tbl.Vel then return self:Finish() end

    self.pos = self.tbl.Pos or self.pos
    self.vel = self.tbl.Vel or self.vel
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
    if not self.vel then return end

    render.StartBeam(20)
        render.SetMaterial(mat_trail)
        for i = 20, 2, -1 do
            self.trail_points[i] = self.trail_points[i - 1]
            render.AddBeam(self.trail_points[i], 5 - i * 0.25, i * 0.5, color_trail)
        end
        self.trail_points[1] = self.pos + self.vel
        render.AddBeam(self.trail_points[1], 5, 0, color_white)
    render.EndBeam()
    if self.finishing then return end
    render.SetMaterial(mat)
    render.DrawQuadEasy(self.pos + self.vel, -EyeVector(), 8, 8, color_white)
end