local mat = Material("nature/blendgrassgrass001a")
mat:SetTexture("$basetexture", "nature/snowfloor001a")
mat:SetTexture("$basetexture2", "nature/sandfloor010a")

local mat2 = Material("maps/gm_drivingmap_mk1-98/nature/blendgrassgrass001a_wvt_patch")
mat2:SetTexture("$basetexture", "nature/snowfloor001a")

local mat3 = Material("nature/blendgrassgravel001a")
mat3:SetTexture("$basetexture", "nature/snowfloor001a")
mat3:SetTexture("$basetexture2", "nature/gravelfloor002a")

local mat4 = Material("nature/blendmilground004_rock2")
mat4:SetTexture("$basetexture", "nature/snowwall001a")
mat4:SetTexture("$basetexture2", "nature/snowfloor001a")
mat4:SetVector("$color", Vector(0.8, 0.8, 0.8))

local mat5 = Material("nature/blendcliffdirt001a")
mat5:SetTexture("$basetexture", "nature/snowwall001a")
mat5:SetTexture("$basetexture2", "nature/snowfloor001a")
mat5:SetVector("$color", Vector(0.8, 0.8, 0.8))

local mat6 = Material("de_train/train_grass_floor_01")
mat6:SetTexture("$basetexture", "nature/snowfloor001a")


local sky = {"bk",  "dn", "ft", "lf", "rt", "up"}

for i, v in ipairs(sky) do
	local skyplane = Material("skybox/bluesky"..v)
	skyplane:SetTexture("$basetexture", "skybox/sky_day02_04"..v)
	skyplane:SetInt("$nofog", 0)
	skyplane:SetVector("$color", Vector(1.5, 1.5, 1.5))
end

return {
	["**displacement**"] = true,
	["maps/gm_drivingmap_mk1-98/nature/blendgrassgrass001a_wvt_patch"] = true,
	["DE_TRAIN/TRAIN_GRASS_FLOOR_01"] = true
}
