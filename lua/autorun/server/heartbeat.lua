timer.Create("serverhealth_heartbeat", 5, 0, function()
    file.Write("serverhealth/heartbeat.txt", "1")
end)