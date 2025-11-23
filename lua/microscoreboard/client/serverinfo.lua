PANEL = {}

local fTickInfo2 = 1 / engine.TickInterval()
timer.Create("MS_ServerInfo_Tickrate", 0.1, 0, function() MICRO_SCOREBOARD.tickrate = math.floor(math.min(1 / engine.ServerFrameTime(), fTickInfo2)) end)

local TrackedValues = {
    {Value = "edicts", Info1 = "Edicts", Info2 = 8096},
    {Value = "modelprecache", Info1 = "Model Precache", Info2 = 8096},
    {Value = "soundprecache", Info1 = "Sound Precache", Info2 = 16384},
    {Value = function() return GetGlobal2Int("cpu_load") end, Info1 = "CPU Usage", Info2 = "%"},
    {Value = function() return MICRO_SCOREBOARD.tickrate end, Info1 = "Tickrate"},
    {Value = function() return math.Round(collectgarbage("count") / 1024, 1) end, Info1 = "Garbage", Info2 = " MB"},
    {Value = function() return math.floor(1 / FrameTime()) end, Info1 = "Framerate"},
}

function PANEL:Init()
    self:SetSize(120, 400)
    self:SetPos(ScrW() + 5, ScrH() - 420)
    self:SetTitle("")
    self:DockPadding(0, 0, 0, 0)
    self:ShowCloseButton(true)
    self:SetDraggable(false)
    self:SetSizable(false)
    self:ParentToHUD()
    self.isOpen = false
    for i, v in ipairs(TrackedValues) do
        local infopanel = self:Add("MS_InfoPanel")
        infopanel:Dock(TOP)
        infopanel:SetupInfo(v.Value, v.Info1, v.Info2)
    end
end

function PANEL:Open()
    self.isOpen = true
    self:SetVisible(true)
    self:MoveTo(ScrW() - 120, ScrH() - 420, 0.5, 0, 0.2)
end

function PANEL:Close()
    self.isOpen = false
    self:MoveTo(ScrW(), ScrH() - 420, 0.5, 0, 0.2, function()
        if not self.isOpen then self:SetVisible(false) end
    end)
end

function PANEL:Paint() end

vgui.Register("MS_ServerInfo", PANEL, "DFrame")