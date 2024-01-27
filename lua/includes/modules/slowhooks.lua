AddCSLuaFile()

timer.Create("SlowThink", FrameTime() * 3, 0, function() hook.Run("SlowThink") end)
timer.Create("SlowTick", engine.TickInterval() * 3, 0, function() hook.Run("SlowTick") end)



