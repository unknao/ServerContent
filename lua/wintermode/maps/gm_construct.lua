local mat = Material("gm_construct/grass-sand_13")
mat:SetTexture("$basetexture", "nature/snowfloor003a")
mat:SetTexture("$basetexture2", "nature/dirtfloor012a")

mat = Material("gm_construct/grass_13")
mat:SetTexture("$basetexture", "nature/snowfloor003a")
mat:SetTexture("$basetexture2", "nature/snowfloor001a")

mat = Material("gm_construct/flatgrass")
mat:SetTexture("$basetexture", "nature/snowfloor003a")
mat:SetTexture("$basetexture2", "nature/snowfloor001a")

mat = Material("gm_construct/flatgrass_2")
mat:SetTexture("$basetexture", "nature/snowfloor003a")
mat:SetTexture("$basetexture2", "nature/snowfloor001a")

mat = Material("models/props_foliage/tree_springers_cards_01.vmt")
mat:SetTexture("$basetexture", "NULL")

hook.Add("SetupWorldFog", "gm_redrock.fog", function()
	render.FogMode(1)
	render.FogStart(0)
	render.FogEnd(9500)
	 render.FogMaxDensity(1)
	render.FogColor(249.9, 249.9, 249.9)
	return true
end)

hook.Add("SetupSkyboxFog", "gm_redrock.fog", function()
	render.FogMode(1)
	render.FogStart(0)
	render.FogEnd(593.75)
	 render.FogMaxDensity(1)
	render.FogColor(249.9, 249.9, 249.9)
	return true
end)


--no skybox on this map
local sky = ents.FindByClass("env_skypaint")[1]
sky:SetDuskColor(Vector(1, 1, 1))
sky:SetBottomColor(Vector(1, 1, 1))
sky:SetTopColor(Vector( 0.34, 0.59, 1.0 ))

return {
	["**displacement**"] = true
}
