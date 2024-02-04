local function CreateScoreboard()
    if IsValid(MICRO_SCORE.Scoreboard) then MICRO_SCORE.Scoreboard:Remove() end

    MICRO_SCORE.Scoreboard = vgui.Create("DScoreboardFrame")
    MICRO_SCORE.Scoreboard:SetVisible(false)
end

local function CreateInfoPanel()
    if IsValid(MICRO_SCORE.InfoPanel) then MICRO_SCORE.InfoPanel:Remove() end

    MICRO_SCORE.InfoPanel = vgui.Create("DServerInfo")
    MICRO_SCORE.InfoPanel:SetVisible(false)
end

concommand.Add("recreatescoreboard", function()
    CreateScoreboard()
    CreateInfoPanel()
end)

hook.Add("ScoreboardShow", "Micro_Scoreboard", function()
    if not IsValid(MICRO_SCORE.Scoreboard) then
        CreateScoreboard()
    end
    MICRO_SCORE.Scoreboard:SetVisible(true)
    MICRO_SCORE.Scoreboard:MakePopup()
    MICRO_SCORE.Scoreboard:SetKeyboardInputEnabled(false)

    if not IsValid(MICRO_SCORE.InfoPanel) then
        CreateInfoPanel()
    end
    MICRO_SCORE.InfoPanel:SetVisible(true)
    return true
end)

hook.Add("ScoreboardHide", "Micro_Scoreboard", function()
    if not IsValid(MICRO_SCORE.Scoreboard) then
        CreateScoreboard()
    end
    MICRO_SCORE.Scoreboard:SetVisible(false)
    if MICRO_SCORE.Menu then MICRO_SCORE.Menu:Remove() end

    if not IsValid(MICRO_SCORE.InfoPanel) then
        CreateInfoPanel()
    end
    MICRO_SCORE.InfoPanel:SetVisible(false)
end)