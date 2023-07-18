--Replace the initial drown sound.
require("finishedloading")

hook.Add("EntityEmitSound", tag, function(data)
	
	local ent = data.Entity
	
	if not ent:IsPlayer() then return end
	if ent:IsBot() then return end
	if not ent._just_spawned then return end
	
	data.SoundName = "garrysmod/content_downloaded.wav"
	
	return true
	
end)