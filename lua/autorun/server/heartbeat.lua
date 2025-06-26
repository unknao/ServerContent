timer.Create("serverhealth_heartbeat", 5, 0, function()
    file.Write("sv_heartbeat.txt", "1")
end)