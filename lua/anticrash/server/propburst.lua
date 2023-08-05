local tag = "anticrash_prop_burst"
local limit = CreateConVar("anticrash_prop_burst_limit", 3, {FCVAR_ARCHIVE}, "Sets the limit of how many props a player can spawn in a tick.")

local function prop_burst(ply)
	if ply.propburst_time ~= CurTime() then
		ply.props_spawned_this_tick = 0
	else
		ply.props_spawned_this_tick = ply.props_spawned_this_tick + 1
	end
	ply.propburst_time = CurTime()
	
	if ply.props_spawned_this_tick >= limit:GetInt() then return false end
end

hook.Add("PlayerSpawnProp", tag, prop_burst)
hook.Add("PlayerSpawnSENT", tag, prop_burst)
hook.Add("PlayerSpawnSWEP", tag, prop_burst)
hook.Add("PlayerSpawnRagdoll", tag, prop_burst)