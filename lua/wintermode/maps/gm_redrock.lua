local mat = Material("custommaterials/blendrock")
mat:SetTexture("$basetexture", "nature/snowfloor002a")
mat:SetTexture("$basetexture2", "nature/snowfloor003a")

local mat2 = Material("models/props_wasteland/rockcliff02a")
mat2:SetTexture("$basetexture", "nature/rockwall010b")

local sky = {"bk",  "dn", "ft", "lf", "rt", "up"}

local scalematrix = Matrix({
	{ 1, 0, 0, 0 },
	{ 0, 2, 0, 0 },
	{ 0, 0, 0, 0 },
	{ 0, 0, 0, 0 }
})

for i, v in ipairs(sky) do
	local skyplane = Material("skybox/thickclouds"..v)
	skyplane:SetTexture("$basetexture", "skybox/sky_day01_05"..v)
	if v == "up" then continue end
	
	Material("skybox/thickclouds"..v):SetMatrix("$basetexturetransform", scalematrix)
end

hook.Add("SetupWorldFog", "gm_redrock.fog", function()
	render.FogMode(1)
	render.FogStart(0)
	render.FogEnd(14000)
	 render.FogMaxDensity(0.95)
	render.FogColor(221.85, 221.85, 221.85)
	return true
end)

hook.Add("SetupSkyboxFog", "gm_redrock.fog", function()
	render.FogMode(1)
	render.FogStart(0)
	render.FogEnd(875)
	 render.FogMaxDensity(0.95)
	render.FogColor(221.85, 221.85, 221.85)
	return true
end)

return {
	["**displacement**"] = true,
}