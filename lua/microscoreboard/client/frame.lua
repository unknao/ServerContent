local PANEL = {}
surface.CreateFont("micro_scoreboard_hostname_32",{
    font = "a Akhir Tahun",
    size = 30,
    antialias = false,
    outline = false,
    weight = 3000
})

local micro_scoreboard_max_players = CreateConVar("micro_scoreboard_max_players", "10", {FCVAR_ARCHIVE}, "Determines how many players can be on the scoreboard without a scroll bar.")
local ms_frames = {}

function PANEL:UpdateSize(Count)
    local y = 85 + (23 * (math.min(Count, micro_scoreboard_max_players:GetInt()) - 1))
    self.desiredSize = y
    if not self.isOpen then return end

    self:SizeTo(-1, self.desiredSize, 0.5, 0, 0.2)
    self:MoveTo(ScrW() / 2 - 350, ScrH() / 2 - self.desiredSize / 2, 0.5, 0, 0.2)
end

function PANEL:GetScrollPanel() return self.scrollPanel end
function PANEL:GetPlayerPanels() return self.playerPanels end

function PANEL:AddPlayerPanel(ply)
    if not self.scrollPanel then print("Micro Scoreboard Error: scroll panel missing!!") return end
    local id = ply:UserID()
    if self.playerPanels[id] then return end

    self.playerPanels[id] = self.scrollPanel:Add("MS_PlayerInfo")
    self.playerPanels[id]:Dock(TOP)
    self.playerPanels[id]:SetPlayer(ply)
end

function PANEL:Init()
    self.id = table.insert(ms_frames, self)
    self:SetSize(700, 0)
    self:Center()
    self:DockPadding(5, 35, 5, 30)
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self:SetSizable(false)
    self.isOpen = false

    self.scrollPanel = self:Add("DScrollPanel")
    self.scrollPanel:Dock(FILL)

    local sbar = self.scrollPanel:GetVBar()
    sbar:SetWide(5)
    sbar:SetHideButtons(true)
    function sbar:Paint(w, h) end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, MICRO_SCOREBOARD.Player_BGColor_Hovered)
    end

    self.playerPanels = {}
    for _, ply in ipairs(player.GetAll()) do
        self:AddPlayerPanel(ply)
    end
    self:UpdateSize(player.GetCount())
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(MICRO_SCOREBOARD.Frame_Color)
    surface.DrawRect(0, 30, w, h - 55)

    surface.SetFont("micro_scoreboard_player_panel_16")
    local Info1 = "Players: " .. player.GetCount() .. " / Map: " .. game.GetMap()
    local x1 = surface.GetTextSize(Info1)
    surface.DrawRect(0, h - 25, 16 + x1, 25)
    draw.SimpleText(Info1, "micro_scoreboard_player_panel_16", 8, h - 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)


    local Info2 = "Click to teleport to player"
    local x2 = surface.GetTextSize(Info2)
    surface.DrawRect(w - 16 - x2, h - 25, 16 + x2, 25)
    draw.SimpleText(Info2, "micro_scoreboard_player_panel_16", w - 8, h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

    --draw.SimpleText(GetHostName(), "micro_scoreboard_hostname_32", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    draw.SimpleTextOutlined(GetHostName(), "micro_scoreboard_hostname_32", w / 2, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
end

function PANEL:Open()
    self.isOpen = true
    self:SetVisible(true)
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)
    self:SizeTo(-1, self.desiredSize, 0.5, 0, 0.2)
    self:MoveTo(ScrW() / 2 - 350, ScrH() / 2 - self.desiredSize / 2, 0.5, 0, 0.2)
end

function PANEL:Close()
    self.isOpen = false
    self:SetMouseInputEnabled(false)
    self:SizeTo(-1, 0, 0.5, 0, 0.2)
    self:MoveTo(ScrW() / 2 - 350, ScrH() / 2, 0.5, 0, 0.2, function()
        if not self.isOpen then self:SetVisible(false) end
    end)
end

function PANEL:OnRemove()
    table.remove(ms_frames, self.id)
end

vgui.Register("MS_ScoreboardFrame", PANEL, "DFrame")

hook.Add("OnEntityCreated", "MICRO_SCOREBOARDboard_PlayerJoin", function(ply)
    if not ply:IsPlayer() then return end

    for _, pnl in ipairs(ms_frames) do
        if not pnl:GetScrollPanel() then continue end

        pnl:AddPlayerPanel(ply)
        pnl:UpdateSize(player.GetCount())
    end
end)