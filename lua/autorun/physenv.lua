local Phys_Defaults = {
	["MaxCollisionChecksPerTimestep"] = 50000,
	["MaxCollisionsPerObjectPerTimestep"] = 10,
	["LookAheadTimeObjectsVsObject"] = 0.5,
	["MaxVelocity"] = 4000,
	["MinFrictionMass"] = 10,
	["MaxFrictionMass"] = 2500,
	["LookAheadTimeObjectsVsWorld"] = 1,
	["MaxAngularVelocity"] = 7273,
}

for k, v in pairs(Phys_Defaults) do
	local cvarname = "phys_" .. k:lower()
	CreateConVar(cvarname, v, FCVAR_NOTIFY)
	cvars.AddChangeCallback(cvarname, function(_, _, new)
		physenv.SetPerformanceSettings({[k] = tonumber(new)})
	end)
end
