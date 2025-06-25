local tag = "timeout_autoretry"
local url = GetConVar("sv_downloadurl"):GetString()
local token

http.Fetch(url .. "/token.txt", function(str)
    token = str
end)

timer.Create(tag, 3, 0, function()
    if not GetTimeoutInfo() then return end

    http.Fetch(url .. "/token.txt", function(str)
        if str == token then return end

        timer.Remove(tag)
        print("Server is restarting, rejoining shortly.")
        timer.Simple(10, function()
            RunConsoleCommand("retry")
        end)
    end)
end)