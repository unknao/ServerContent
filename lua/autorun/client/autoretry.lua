local tag = "timeout_autoretry"
local url = GetConVar("sv_downloadurl"):GetString()
local server_instance

http.Fetch(url .. "/serverinstance.txt", function(str)
    server_instance = str
end)

timer.Create(tag, 3, 0, function()
    if not GetTimeoutInfo() then return end

    http.Fetch(url .. "/serverinstance.txt", function(str)
        if str == server_instance then return end

        timer.Remove(tag)
        print("Server is restarting, rejoining shortly.")
        timer.Simple(10, function()
            RunConsoleCommand("retry")
        end)
    end)
end)