--Replace the initial drown sound.
require("finishedloading")

hook.Add("EntityEmitSound", "joinsound", function(data)
	local ent = data.Entity
	if not ent:IsPlayer() then return end
	if ent:IsBot() then return end
	if not ent._just_spawned then return end

	return false
end)