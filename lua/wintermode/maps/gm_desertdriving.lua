local mat = Material("de_dust/rockwall_blend")
mat:SetTexture("$basetexture", "nature/snowfloor001a")
mat:SetTexture("$basetexture2", "nature/snowfloor002a")


mat:SetVector("$color", Vector(1, 1, 1))

if SERVER then
	local sun = ents.FindByClass( "env_sun" )[1]
	if IsValid(sun) then
		sun:Remove()
	end
end

local scalematrix = Matrix({
	{ 0, 1, 0, 0 },
	{ -1, 0, 0, 0 },
	{ 0, 0, 0, 0 },
	{ 0, 0, 0, 0 }
})

hook.Add("SetupWorldFog", "gm_desertdriving.fog", function()
	render.FogMode(1)
	render.FogStart(0)
	render.FogEnd(8192)
	 render.FogMaxDensity(1)
	render.FogColor(175.95, 201.45, 201.45)
	return true
end)

local sky = {"bk",  "dn", "ft", "lf", "rt", "up"}
local skyorder = {"rt",  "dn", "lf", "bk", "ft", "up"}

for i, v in ipairs(sky) do
	local skyplane = Material("skybox/sky_day01_08"..v)
	skyplane:SetTexture("$basetexture", "skybox/sky_wasteland02"..skyorder[i])
	if v == "up" then 
		Material("skybox/sky_day01_08"..v):SetMatrix("$basetexturetransform", scalematrix)
	end
end

return {["**displacement**"] = true}