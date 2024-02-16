local tag = "DistantGunshots"
local tOverride = {
    [")weapons/smg1/smg1_fire1.wav"] = "^weapons/smg1/npc_smg1_fire1.wav",
    [")weapons/pistol/pistol_fire2.wav"] = "^weapons/pistol/pistol_fire3.wav",
    [")weapons/ar2/fire1.wav"] = "^weapons/ar1/ar1_dist1.wav"
}
hook.Add("EntityEmitSound", tag, function(data)
    if not data.Entity:IsPlayer() then return end
    if not  tOverride[data.SoundName] then return end

    data.SoundName = tOverride[data.SoundName]
    return true
end)