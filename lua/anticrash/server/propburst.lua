local tag = "prop_burst"
local anticrash_prop_burst_limit = 3

local function prop_burst(ply)
	ply.ac_last_spawn_time = ply.ac_spawn_time
	ply.ac_spawn_time = CurTime()
	
	if ply.ac_last_spawn_time == ply.ac_spawn_time then
		ply.ac_propburst = ply.ac_propburst + 1
		else
		ply.ac_propburst = 0
	end
	if ply.ac_propburst >= anticrash_prop_burst_limit then return false end
end

hook.Add("PlayerSpawnProp", tag, prop_burst)
hook.Add("PlayerSpawnSENT", tag, prop_burst)
hook.Add("PlayerSpawnSWEP", tag, prop_burst)
hook.Add("PlayerSpawnRagdoll", tag, prop_burst)