PANEL = {}

function PANEL:Init()
    self:SetTall(40)
    self:SetText("")
    self:DockMargin(0, 0, 0, 3)
    self.Value = ""
    self.Info1 = ""
    self.Info2 = 0
end

function PANEL:SetupInfo(Value, Info1, Info2)
    self.Value = Value
    self.Info1 = Info1
    if isnumber(Info2) then
        self.Info2 = " / " .. Info2
    else
        self.Info2 = Info2 or ""
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self:IsHovered() and MICRO_SCOREBOARD.Player_BGColor_Hovered or MICRO_SCOREBOARD.Player_BGColor)
    surface.DrawRect(0, 0, w, 20)
    draw.SimpleText(self.Info1, "MICRO_SCOREBOARDboard_16", w / 2, 10, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(MICRO_SCOREBOARD.Frame_Color)
    surface.DrawRect(0, 20, w, h - 20)
    if isfunction(self.Value) then
        draw.SimpleText(self.Value() .. self.Info2, "MICRO_SCOREBOARDboard_16", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(nw3.GetGlobalInt(self.Value) .. self.Info2, "MICRO_SCOREBOARDboard_16", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("MS_InfoPanel", PANEL, "DButton")