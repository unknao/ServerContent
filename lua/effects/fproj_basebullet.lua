function EFFECT:Init(Data)
    self.Parent = Data:GetEntity()
    self.tbl = fproj.ProjectileTable[self.Parent][#fproj.ProjectileTable[self.Parent]]
    self:SetModel("models/props_junk/CinderBlock01a.mdl")
    self.ParticleEmitter = ParticleEmitter(self:GetPos())
end

function EFFECT:Think()
    if not self.tbl then return self:Finish() end
    if not self.tbl.Vel then return self:Finish() end

    self:SetPos(self.tbl.Pos + self.tbl.Vel)
    return true
end

function EFFECT:Finish()
    self.ParticleEmitter:Finish()
    return false
end

local mat = Material( "sprites/orangeflare1" )
function EFFECT:Render()
    if not self.tbl then return end

    render.SetMaterial(mat)
    render.DrawQuadEasy(self.tbl.Pos + self.tbl.Vel, -EyeVector(), 3, 3, color_white)

    local Light = self.ParticleEmitter:Add("sprites/orangeflare1.vmt", self:GetPos())
    if Light then

        Light:SetVelocity(self.tbl.Vel * 35)
        Light:SetColor(255, 255, 255)
        Light:SetDieTime(0.25)
        Light:SetStartAlpha(255)
        Light:SetEndAlpha(0)
        Light:SetStartSize(3)
        Light:SetEndSize(0)
    end
end