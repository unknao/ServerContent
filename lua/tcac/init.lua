tcac = tcac or {
    detours = {}
}
local function LoadFolder(path)
    for _, files in ipairs(file.Find(path .. "/*.lua", "LUA")) do
        include(path .. files)
    end
end

local _, Folders = file.Find("tcac/*", "LUA")
for _, dir in ipairs(Folders) do
   LoadFolder("tcac/" .. dir .. "/")
end
