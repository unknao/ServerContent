local settings={
	MaxCollisionChecksPerTimestep = 1000,
	MaxCollisionsPerObjectPerTimestep = 250,
	MaxAngularVelocity = 50000,
	MaxVelocity = 50000
}
hook.Add("InitPostEntity","physenv",function()
	physenv.SetPerformanceSettings(settings)
end)