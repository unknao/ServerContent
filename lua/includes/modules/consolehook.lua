_RunConsoleCommand = _RunConsoleCommand or RunConsoleCommand
_game_ConsoleCommand = _game_ConsoleCommand or game.ConsoleCommand

--[[
hook.Add("ConsoleCommand", "example", function(cmd, args)
    return true --Return true to suppress console command
end)
]]--

function RunConsoleCommand(...)
    local Args = {...}
    local shouldnt_run = hook.Run("ConsoleCommand", Args[1], unpack(Args, 2))
    if shouldnt_run then return end

    _RunConsoleCommand(...)
end

function game.ConsoleCommand(cmd)
    local str = string.match(cmd, "^(.+)%c$") --Remove newlines
    local Args = string.Split(str, " ")
    local shouldnt_run = hook.Run("ConsoleCommand", Args[1], unpack(Args, 2))
    if shouldnt_run then return end

    _game_ConsoleCommand(cmd)
end