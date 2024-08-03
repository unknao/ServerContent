local PANEL = {}
surface.CreateFont("Micro_Scoreboard_32",{
    font = "a Akhir Tahun",
    size = 30,
    antialias = false,
    outline = false,
    weight = 3000
})
MICRO_SCORE.PlayerPanels = {}
local Max_Players_On_Scoreboard = CreateConVar("scoreboard_maxplayers", "10", {FCVAR_ARCHIVE}, "Determines how many players can be on the scoreboard without a scroll bar.")


function PANEL:UpdateSize(Count)
    local y = 85 + (23 * (math.min(Count, Max_Players_On_Scoreboard:GetInt()) - 1))
    self.DesiredSize = y
    if not self.IsOpen then return end

    self:SizeTo(-1, self.DesiredSize, 0.5, 0, 0.2)
    self:MoveTo(ScrW() / 2 - 350, ScrH() / 2 - self.DesiredSize / 2, 0.5, 0, 0.2)
end

function PANEL:Init()
    self:SetSize(700, 0)
    self:Center()
    self:DockPadding(5, 35, 5, 30)
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self:SetSizable(false)
    self.IsOpen = false

    MICRO_SCORE.ScrollPanel = self:Add("DScrollPanel")
    MICRO_SCORE.ScrollPanel:Dock(FILL)

    local sbar = MICRO_SCORE.ScrollPanel:GetVBar()
    sbar:SetWide(5)
    sbar:SetHideButtons(true)
    function sbar:Paint(w, h) end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, MICRO_SCORE.Player_BGColor_Hovered)
    end

    for i, v in ipairs(player.GetAll()) do
        MICRO_SCORE.PlayerPanels[i] = MICRO_SCORE.ScrollPanel:Add("MS_PlayerInfo")
        MICRO_SCORE.PlayerPanels[i]:Dock(TOP)
        MICRO_SCORE.PlayerPanels[i]:SetPlayer(v)
    end
    self:UpdateSize(player.GetCount())
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(MICRO_SCORE.Frame_Color)
    surface.DrawRect(0, 30, w, h - 55)

    surface.SetFont("Micro_Scoreboard_16")
    local Info1 = "Players: " .. player.GetCount() .. " / Map: " .. game.GetMap()
    local x1 = surface.GetTextSize(Info1)
    surface.DrawRect(0, h - 25, 16 + x1, 25)
    draw.SimpleText(Info1, "Micro_Scoreboard_16", 8, h - 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)


    local Info2 = "Click to teleport to player"
    local x2 = surface.GetTextSize(Info2)
    surface.DrawRect(w - 16 - x2, h - 25, 16 + x2, 25)
    draw.SimpleText(Info2, "Micro_Scoreboard_16", w - 8, h - 5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

    --draw.SimpleText(GetHostName(), "Micro_Scoreboard_32", w / 2, 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    draw.SimpleTextOutlined(GetHostName(), "Micro_Scoreboard_32", w / 2, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
end

function PANEL:Open()
    self.IsOpen = true
    self:SetVisible(true)
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)
    self:SizeTo(-1, self.DesiredSize, 0.5, 0, 0.2)
    self:MoveTo(ScrW() / 2 - 350, ScrH() / 2 - self.DesiredSize / 2, 0.5, 0, 0.2)
end

function PANEL:Close()
    self.IsOpen = false
    self:SetMouseInputEnabled(false)
    self:SizeTo(-1, 0, 0.5, 0, 0.2)
    self:MoveTo(ScrW() / 2 - 350, ScrH() / 2, 0.5, 0, 0.2, function()
        if not self.IsOpen then self:SetVisible(false) end
    end)
end

hook.Add("OnEntityCreated", "Micro_Scoreboard_PlayerJoin", function(ply)
    if not ply:IsPlayer() then return end
    if ply == LocalPlayer() then return end
    if not MICRO_SCORE.Scoreboard then return end
    if not MICRO_SCORE.ScrollPanel then return end
    if not MICRO_SCORE.PlayerPanels then return end

    local id = ply:UserID()
    MICRO_SCORE.PlayerPanels[id] = MICRO_SCORE.ScrollPanel:Add("MS_PlayerInfo")
    MICRO_SCORE.PlayerPanels[id]:Dock(TOP)
    MICRO_SCORE.PlayerPanels[id]:SetPlayer(ply)
    MICRO_SCORE.Scoreboard:UpdateSize(player.GetCount())
end)

hook.Add("OnNW3ReceivedEntityValue", "micro_scoreboard_flag_update", function(entindex, _, id, var)
    local panel = MICRO_SCORE.PlayerPanels[entindex]
    if not panel then return end

    if id == "country_code" then
        panel:UpdateFlag(Var)
    elseif id == "country" then
        panel:UpdateCountryName(var)
    end
end)

vgui.Register("MS_ScoreboardFrame", PANEL, "DFrame")