local Whitelist = {
    ["Default"] = true,
    ["Wiremod"] = true,
    ["Other"] = true
}
hook.Add("PreRegisterSWEP", "weaponstab", function(swep)
    if not Whitelist[swep.Category] then return false end
end)