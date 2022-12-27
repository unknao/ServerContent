local entmeta = FindMetaTable("Entity")
ac_detours.SetModelScale = ac_detours.SetModelScale or entmeta.SetModelScale

function entmeta.SetModelScale(ent, scale, deltatime)
	local scale = SERVER and math.Clamp(scale, -10, 10) or math.Clamp(scale, -50, 50)
	ac_detours.SetModelScale(ent, scale, deltatime)
end

