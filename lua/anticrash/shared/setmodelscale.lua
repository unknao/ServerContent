local Entity = FindMetaTable("Entity")
ac_detours.SetModelScale = ac_detours.SetModelScale or Entity.SetModelScale

function Entity:SetModelScale(scale, deltatime)
	local scale = SERVER and math.Clamp(scale, -10, 10) or math.Clamp(scale, -50, 50)

	ac_detours.SetModelScale(self, scale, deltatime)
end

