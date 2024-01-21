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

hook.Add("InitPostEntity","physenv",function()
	for k, v in pairs(Phys_Defaults) do
		local cvarname = "phys_" .. k:lower()
		local physcvar = CreateConVar(cvarname, v, FCVAR_NOTIFY)
		cvars.AddChangeCallback(cvarname, function(_, _, new)
			physenv.SetPerformanceSettings({k = new})
		end)

		physenv.SetPerformanceSettings({k = physcvar:GetInt()})
	end
end)
