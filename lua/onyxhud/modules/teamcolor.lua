ONYXHUD.Colors = ONYXHUD.Colors or {}
hook.Add("CreateTeams", "onyxhud_teamcolors", function()
    timer.Simple(0, function()
        local team_table = team.GetAllTeams()

        for i = 1, #team_table do
            local team_color = team_table[i].Color
            ONYXHUD.Colors[i] = {team_color, Color(team_color.r * 0.25, team_color.g * 0.25, team_color.b * 0.25)}
        end
    end)
end)
