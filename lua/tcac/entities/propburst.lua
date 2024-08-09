local tag = "TCAC_PropBurstLimit"
local iLimit = CreateConVar(tag, 3, {FCVAR_ARCHIVE}, "Sets the limit of how many props a player can spawn in a tick.")
--We shouldn't trust the client to not spawn 600 entities in a single tick.
print(10)

local function CanSpawn(ply)
	if ply.PropBurstTime ~= CurTime() then
		ply.PropsSpawnedThisTick = 0
	else
		ply.PropsSpawnedThisTick = ply.PropsSpawnedThisTick + 1
	end
	ply.PropBurstTime = CurTime()

	if ply.PropsSpawnedThisTick >= iLimit:GetInt() then return false end
end

hook.Add("PlayerSpawnObject", tag, CanSpawn)