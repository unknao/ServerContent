PANEL = {}
require("slowthink")

local fTickMax = 1 / engine.TickInterval()
hook.Add("SlowThink", "MicroScore_Tickrate", function() MICRO_SCORE.tickrate = math.floor(math.min(1 / engine.ServerFrameTime(), fTickMax)) end)

local TrackedValues = {
    {Name = "edicts", NiceName = "Edicts", Max = 8096},
    {Name = "modelprecache", NiceName = "Model Precache", Max = 8096},
    {Name = "soundprecache", NiceName = "Sound Precache", Max = 16384},
    {Name = function() return GetGlobal2Int("cpu_load") end, NiceName = "CPU Usage", Max = "%"},
    {Name = function() return MICRO_SCORE.tickrate end, NiceName = "Tickrate"},
    {Name = function() return math.Round(collectgarbage("count") / 1024, 1) end, NiceName = "Garbage", Max = " MB"},
    {Name = function() return math.floor(1 / FrameTime()) end, NiceName = "Framerate"},
}

function PANEL:Init()
    self:SetSize(120, 400)
    self:SetPos(ScrW() - 120, ScrH() - 420)
    self:SetTitle("")
    self:DockPadding(0, 0, 0, 0)
    self:ShowCloseButton(true)
    self:SetDraggable(false)
    self:SetSizable(false)
    for i, v in ipairs(TrackedValues) do
        local infopanel = self:Add("DInfoPanel")
        infopanel:Dock(TOP)
        infopanel:SetupInfo(v.Name, v.NiceName, v.Max)
    end
end

function PANEL:Paint() end

vgui.Register("DServerInfo", PANEL, "DFrame")