--[[
	Original: https://github.com/noaccessl/glua-SVG
	-Modified by unknao to be more performant and easier to load as a library.

	Can be require()'d as is, no need for janky requiring procedures.
	Usage:
	Cache your svg first
	svg.Generate(string ID, number width, number height, string SVGCode) (https://icon666.com is a good site to get SVG codes)

	Then draw it
	svg.Draw(string ID, number x, number y)

	Note: it can't draw animated SVGs.
]]

AddCSLuaFile()
if SERVER then return end
local svg_debugprint = CreateConVar("svg_debugprint", 0, FCVAR_ARCHIVE, "Prints useful debugging information throughout the svg material acquisition process", 0, 1)

svg = svg or {
	Cache = {},
	Coroutines = {},
}
local Proceed = false
hook.Add("OnGamemodeLoaded", "SVG_CanWork", function() --Workaround for not being able to make derma panels right away
	timer.Simple(0, function()
		Proceed = true
		for _, co in ipairs(svg.Coroutines) do
			coroutine.resume(co)
		end
		svg.Coroutines = nil
	end)
end)

local SVGTemplate = [[
<html>
	<head>
		<style>
			body {
				margin: 0;
				padding: 0;
				overflow: hidden;
			}
		</style>
	</head>
	<body>
		%s
	</body>
</html>
]]

function svg.ClearCache()
	for ID, _ in pairs(svg.Cache) do
		svg.Cache[ID] = nil
	end
end

function svg.Remove(ID)
	svg.Cache[ID] = nil
end

function svg.GetMaterial(ID)
	local svgdata = svg.Cache[ID]
	if not istable(svgdata) then
		return
	end

	return svgdata.mat
end

function svg.GetTable(ID)
	local svgdata = svg.Cache[ID]
	if not istable(svgdata) then
		error(string.format("attempted to use an unregistered svg material %q", ID))
		return
	end

	return svgdata
end

function svg.IsValid(ID)
	return istable(svg.Cache[ID])
end

local function debugprint(ID, str)
	if not svg_debugprint:GetBool() then return end

	print(string.format("[SVG_DEBUG]: %q %s", ID, str))
end

function svg.Generate(...)
	coroutine.resume(coroutine.create(function(ID, w, h, strSVG, callback)
		debugprint(ID, "Material creation started.")
		local coRunning = coroutine.running()

		if not isstring(strSVG) then
			error("expected string, got " .. type(strSVG))
		end
		local open = string.find( strSVG, "<svg%s(.-)>" )
		local _, close = string.find( strSVG, "</svg>%s*$" )
		assert(( open and close ) ~= nil, "Invalid SVG")

		strSVG = string.sub( strSVG, open, close )
		strSVG = string.gsub( strSVG, [[width="(.-)"]], string.format([[width="%i"]], w ))
		strSVG = string.gsub( strSVG, [[height="(.-)"]], string.format([[height="%i"]], h))

		if not Proceed then --Wait until derma panels can be made if necessary
			debugprint(ID, "Derma library not loaded, waiting for it to load...")
			table.insert(svg.Coroutines, coRunning)
			coroutine.yield()
			debugprint(ID, "Client loading complete!")
		end

		print(5)
		local HTML_Panel = vgui.Create("DHTML")
		HTML_Panel:SetVisible(false)
		HTML_Panel:SetHTML(SVGTemplate:format(strSVG))
		HTML_Panel:SetSize(w, h)
		HTML_Panel:UpdateHTMLTexture()
		debugprint(ID, "HTML panel created.")
		HTML_Panel.OnFinishLoadingDocument = function(self)
			self:UpdateHTMLTexture()
			timer.Create("SVG_" .. ID, 0, 0, function()
				if not self:GetHTMLMaterial() then return end
				if self:GetHTMLMaterial():IsError() then return end --Code might randomly fail here because GetHTMLMaterial doesn't always return something

				coroutine.resume(coRunning, self:GetHTMLMaterial():GetName())
				timer.Remove("SVG_" .. ID)
			end)
		end

		local SVG_Mat
		local SVG_Texture = coroutine.yield()
		debugprint(ID, "Texture acquired.")
		if svg.IsValid(ID) then
			SVG_Mat = svg.GetMaterial(ID)
			SVG_Mat:SetTexture("$basetexture", SVG_Texture)
			SVG_Mat:SetInt("$translucent", 1)
			SVG_Mat:SetInt("$vertexalpha", 1)
			SVG_Mat:SetInt("$vertexcolor", 1)
			debugprint(ID, "Previous SVG Material overriden.")
		else
			local SVG_Name = string.format("%s_%i_%i", ID, w, h)
			SVG_Mat = CreateMaterial(SVG_Name, "UnlitGeneric",
			{
				["$basetexture"] = SVG_Texture,
				["$translucent"] = 1,
				["$vertexalpha"] = 1,
				["$vertexcolor"] = 1
			})
			debugprint(ID, "SVG Material created.")
		end

		HTML_Panel:Remove()
		debugprint(ID, "HTML panel removed.")
		svg.Cache[ID] = {mat = SVG_Mat, w = SVG_Mat:Width(), h = SVG_Mat:Height()}
		hook.Run("SVGGenerated", ID, SVG_Mat, w, h)
		debugprint(ID, "Operation Success!")

		if not isfunction(callback) then return end

		callback(SVG_Mat)
		debugprint(ID, "Callback ran.")
	end), ...)
end

function svg.Load(...)
	local tbl = {...}
	local filedir = tbl[1]
	local ID = tbl[2]
	local w = tbl[3]
	local h = tbl[4]
	local callback = tbl[5]

	local strSVG = file.Read(filedir, "DATA")
	assert(strSVG ~= nil, "invalid path")

	svg.Generate(ID, w, h, strSVG, callback)
end

function svg.LoadURL(...)
	local tbl = {...}
	local url = tbl[1]
	local ID = tbl[2]
	local w = tbl[3]
	local h = tbl[4]
	local callback = tbl[5]

	assert(string.GetExtensionFromFilename(url) == "svg", "Invalid SVG")
	http.Fetch(url, function(strSVG)
		svg.Generate(ID, w, h, strSVG, callback)
	end,
	function(err)
		error(err)
	end)
end

function svg.Draw(ID, x, y, color)
	local svgdata = svg.Cache[ID]
	if not istable(svgdata) then
		error(string.format("attempted to use an unregistered svg material %q", ID))
		return
	end

	surface.SetDrawColor(color or color_white)

	surface.SetMaterial(svgdata.mat)
	surface.DrawTexturedRect(x, y, svgdata.w, svgdata.h)
end