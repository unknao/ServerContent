local function CreateScoreboard()
    if IsValid(MICRO_SCOREBOARD.Scoreboard) then MICRO_SCOREBOARD.Scoreboard:Remove() end

    MICRO_SCOREBOARD.Scoreboard = vgui.Create("MS_ScoreboardFrame")
    MICRO_SCOREBOARD.Scoreboard:SetVisible(false)
end

local function CreateInfoPanel()
    if IsValid(MICRO_SCOREBOARD.InfoPanel) then MICRO_SCOREBOARD.InfoPanel:Remove() end

    MICRO_SCOREBOARD.InfoPanel = vgui.Create("MS_ServerInfo")
    MICRO_SCOREBOARD.InfoPanel:SetVisible(false)
end

concommand.Add("recreatescoreboard", function()
    CreateScoreboard()
    CreateInfoPanel()
end)

hook.Add("ScoreboardShow", "MICRO_SCOREBOARDboard", function()
    if not IsValid(MICRO_SCOREBOARD.Scoreboard) then
        CreateScoreboard()
    end
    MICRO_SCOREBOARD.Scoreboard:Open()

    if not IsValid(MICRO_SCOREBOARD.InfoPanel) then
        CreateInfoPanel()
    end
    MICRO_SCOREBOARD.InfoPanel:Open()
    return true
end)

hook.Add("ScoreboardHide", "MICRO_SCOREBOARDboard", function()
    if not IsValid(MICRO_SCOREBOARD.Scoreboard) then
        CreateScoreboard()
    end
    MICRO_SCOREBOARD.Scoreboard:Close()
    if MICRO_SCOREBOARD.Menu then MICRO_SCOREBOARD.Menu:Remove() end

    if not IsValid(MICRO_SCOREBOARD.InfoPanel) then
        CreateInfoPanel()
    end
    MICRO_SCOREBOARD.InfoPanel:Close()
end)
