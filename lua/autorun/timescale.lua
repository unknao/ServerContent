hook.Add("EntityEmitSound", "timescale_soundwarp", function(t)
    local timescale = game.GetTimeScale()
    if timescale == 1 then return end

    t.Pitch = math.Clamp(t.Pitch * timescale, 0, 255)
    return true
end)