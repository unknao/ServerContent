hook.Add("ShutDown", "auto_restart_prevent", function() --Let the srcds watchdog know that we're restarting, not crashing
    file.Write("sv_changedlevel.txt", 1)
end)

hook.Add("GetGameDescription", "sv_heartbeat", function() --Way to know when the server is still alive with hibernating on
    file.Write("sv_heartbeat.txt", "1")
end)