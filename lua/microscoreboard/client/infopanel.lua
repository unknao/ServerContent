PANEL = {}
function PANEL:Init()
    self:SetTall(40)
    self:SetText("")
    self:DockMargin(0, 0, 0, 3)
    self.Name = ""
    self.NiceName = ""
    self.Max = 0
end

function PANEL:SetupInfo(Name, NiceName, Max)
    self.Name = Name
    self.NiceName = NiceName
    if isnumber(Max) then
        self.Max = " / " .. Max
    else
        self.Max = Max or ""
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self:IsHovered() and MICRO_SCORE.Player_BGColor_Hovered or MICRO_SCORE.Player_BGColor)
    surface.DrawRect(0, 0, w, 20)
    draw.SimpleText(self.NiceName, "Micro_Scoreboard_16", w / 2, 10, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(MICRO_SCORE.Frame_Color)
    surface.DrawRect(0, 20, w, h - 20)
    if isfunction(self.Name) then
        draw.SimpleText(self.Name() .. self.Max, "Micro_Scoreboard_16", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(GetGlobal2Int(self.Name) .. self.Max, "Micro_Scoreboard_16", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("DInfoPanel", PANEL, "DButton")