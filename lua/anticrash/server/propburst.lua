local tag = "anticrash_entity_burst_limit"
local anticrash_entity_burst_limit = CreateConVar(tag, 4, {FCVAR_ARCHIVE}, "Sets the limit of how many props a player can spawn in a tick.")
--We shouldn't trust the client to not spawn 600 entities in a single tick.

ANTICRASH_ENTITY_BURST_DATA = ANTICRASH_ENTITY_BURST_DATA or {}
hook.Add("OnEntityCreated", tag, function(ply)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end

	ANTICRASH_ENTITY_BURST_DATA[ply] = {}
end)

hook.Add("EntityRemoved", tag, function(ply)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end

	ANTICRASH_ENTITY_BURST_DATA[ply] = nil
end)

local function CountUp(ply, type)
	if anticrash_entity_burst_limit:GetInt() == 0 then return end

	if not ANTICRASH_ENTITY_BURST_DATA[ply][type] then
		ANTICRASH_ENTITY_BURST_DATA[ply][type] = {1, CurTime()}
		print(ply, type, 1)
		return
	end

	if ANTICRASH_ENTITY_BURST_DATA[ply][type][2] == CurTime() then
		ANTICRASH_ENTITY_BURST_DATA[ply][type][1] = ANTICRASH_ENTITY_BURST_DATA[ply][type][1] + 1
		print(ply, type, ANTICRASH_ENTITY_BURST_DATA[ply][type][1])
	else
		ANTICRASH_ENTITY_BURST_DATA[ply][type] = nil
	end
end

local function CanSpawn(ply, type)
	if anticrash_entity_burst_limit:GetInt() == 0 then return end
	local spawned = ANTICRASH_ENTITY_BURST_DATA[ply][type]
	if not spawned then return end

	if spawned[2] ~= CurTime() then
		ANTICRASH_ENTITY_BURST_DATA[ply][type] = nil
		return
	end
	if spawned[1] >= anticrash_entity_burst_limit:GetInt() then
		print(ply, type, "stopped")
		return false
	end
end

hook.Add("PlayerSpawnProp", tag, function(ply)
	return CanSpawn(ply, "prop")
end)
hook.Add("PlayerSpawnEffect", tag, function(ply)
	return CanSpawn(ply, "effect")
end)
hook.Add("PlayerSpawnNPC", tag, function(ply)
	return CanSpawn(ply, "npc")
end)
hook.Add("PlayerSpawnRagdoll", tag, function(ply)
	return CanSpawn(ply, "ragdoll")
end)
hook.Add("PlayerSpawnSENT", tag, function(ply)
	return CanSpawn(ply, "sent")
end)
hook.Add("PlayerSpawnSWEP", tag, function(ply)
	return CanSpawn(ply, "swep")
end)
hook.Add("PlayerSpawnVehicle", tag, function(ply)
	return CanSpawn(ply, "vehicle")
end)

hook.Add("PlayerSpawnedProp", tag, function(ply)
	return CountUp(ply, "prop")
end)
hook.Add("PlayerSpawnedEffect", tag, function(ply)
	return CountUp(ply, "effect")
end)
hook.Add("PlayerSpawednNPC", tag, function(ply)
	return CountUp(ply, "npc")
end)
hook.Add("PlayerSpawnedRagdoll", tag, function(ply)
	return CountUp(ply, "ragdoll")
end)
hook.Add("PlayerSpawnedSENT", tag, function(ply)
	return CountUp(ply, "sent")
end)
hook.Add("PlayerSpawnedSWEP", tag, function(ply)
	return CountUp(ply, "swep")
end)
hook.Add("PlayerSpawnedVehicle", tag, function(ply)
	return CountUp(ply, "vehicle")
end)

