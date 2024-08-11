local tag = "anticrash_prop_burst_limit"
local anticrash_prop_burst_limit = CreateConVar(tag, 3, {FCVAR_ARCHIVE}, "Sets the limit of how many props a player can spawn in a tick.")
--We shouldn't trust the client to not spawn 600 entities in a single tick.

local function CanSpawn(ply)
	if anticrash_prop_burst_limit:GetInt() == 0 then return end

	if ply._prop_burst_time ~= CurTime() then
		ply._props_spawned_recently = 0
	else
		ply._props_spawned_recently = ply._props_spawned_recently + 1
	end
	ply._prop_burst_time = CurTime()

	if ply._props_spawned_recently >= anticrash_prop_burst_limit:GetInt() then return false end
end

hook.Add("PlayerSpawnObject", tag, CanSpawn)