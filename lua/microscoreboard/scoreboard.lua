require("finishedloading")

local function CreateScoreboard()
    MICRO_SCORE.Scoreboard = vgui.Create("DScoreboardFrame")
    MICRO_SCORE.Scoreboard:SetVisible(false)
end

hook.Add("FinishedLoading", "Micro_Scoreboard",function()
    CreateScoreboard()
end)

hook.Add("ScoreboardShow", "Micro_Scoreboard", function()
    if not MICRO_SCORE.Scoreboard then
        CreateScoreboard()
    end
    MICRO_SCORE.Scoreboard:SetVisible(true)
    MICRO_SCORE.Scoreboard:MakePopup()
    MICRO_SCORE.Scoreboard:SetKeyboardInputEnabled(false)
    return true
end)

hook.Add("ScoreboardHide", "Micro_Scoreboard", function()
    if not MICRO_SCORE.Scoreboard then
        CreateScoreboard()
    end
    MICRO_SCORE.Scoreboard:SetVisible(false)
    if MICRO_SCORE.Menu then MICRO_SCORE.Menu:Remove() end
end)