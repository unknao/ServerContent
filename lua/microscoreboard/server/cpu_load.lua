require("cpu_info") --Utilizing binary module from https://github.com/TheFUlDeep/gmod_cpu_info

local tag = "cpu_load"
local Threads = GetProcessorsCount()

timer.Create(tag, 1, 0, function()
    local usage = 0
    for i = 1, Threads do
        usage = usage + GetProcessorLoad(i)
    end
    usage = usage / 16
    SetGlobal2Int(tag, usage)
end)

