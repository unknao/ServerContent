hook.Add("PostGamemodeLoaded","cl_gamemode",function()
    function GAMEMODE:DrawDeathNotice(...) return end
end)