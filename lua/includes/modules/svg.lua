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
	Proceed = false
}

hook.Add("OnGamemodeLoaded", "SVG_CanWork", function() --Workaround for not being able to make derma panels right away
	timer.Simple(0, function()
		svg.Proceed = true
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

function svg.Generate(...)
	coroutine.resume(coroutine.create(function(ID, w, h, strSVG)
		if svg_debugprint:GetBool() then print("[SVG] '" .. ID .. "' Material creation started.") end
		local coRunning = coroutine.running()

		assert(isstring( strSVG ), "Invalid SVG")
		local open = string.find( strSVG, "<svg%s(.-)>" )
		local _, close = string.find( strSVG, "</svg>%s*$" )
		assert(( open and close ) ~= nil, "Invalid SVG")

		strSVG = string.sub( strSVG, open, close )
		strSVG = string.gsub( strSVG, [[width="(.-)"]], string.format([[width="%i"]], w ))
		strSVG = string.gsub( strSVG, [[height="(.-)"]], string.format([[height="%i"]], h))

		if not svg.Proceed then --Wait until derma panels can be made if necessary
			if svg_debugprint:GetBool() then print("[SVG] '" .. ID .. "' Waiting for client to load.") end
			table.insert(svg.Coroutines, coRunning)
			coroutine.yield()
			if svg_debugprint:GetBool() then print("[SVG] '" .. ID .. "' Client loading complete.") end
		end

		local HTML_Panel = vgui.Create("DHTML")
		HTML_Panel:SetVisible(false)
		HTML_Panel:SetHTML(SVGTemplate:format(strSVG))
		HTML_Panel:SetSize(w, h)
		HTML_Panel:UpdateHTMLTexture()
		if svg_debugprint:GetBool() then print("[SVG] '" .. ID .. "' HTML panel created.") end
		HTML_Panel.OnFinishLoadingDocument = function(self)
			self:UpdateHTMLTexture()
			timer.Create("SVG_" .. ID, 0, 0, function()
				if not self:GetHTMLMaterial() then return end
				if self:GetHTMLMaterial():IsError() then return end --Code might randomly fail here because GetHTMLMaterial doesn't always return something
				coroutine.resume(coRunning, self:GetHTMLMaterial():GetName())
				timer.Remove("SVG_" .. ID)
				if svg_debugprint:GetBool() then print("[SVG] '" .. ID .. "' Material acquired, svg creation success.") end
				self:Remove()
			end)
		end

		local SVG_Mat = CreateMaterial(string.format("SVG_%s_%ix%i", ID, w, h), "UnlitGeneric",
		{
			["$basetexture"] = coroutine.yield(),
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1
		})

		svg.Cache[ID] = {mat = SVG_Mat, w = SVG_Mat:Width(), h = SVG_Mat:Height()}
	end), ...)
end

function svg.Load(ID, w, h, path)
	local strSVG = file.Read( path, "DATA" )
	assert( strSVG ~= nil, "invalid path" )

	svg.Generate(ID, w, h, strSVG)
end

function svg.LoadURL(ID, w, h, url)
	assert(string.GetExtensionFromFilename(url) == "svg", "Invalid SVG")

	http.Fetch(url, function(strSVG)
		svg.Generate(ID, w, h, strSVG)
	end,
	function(err)
		error(err)
	end)
end

function svg.Draw(ID, x, y, color)
	local svgdata = svg.Cache[ID]
	if not istable(svgdata) then return end

	surface.SetDrawColor(color or color_white)

	surface.SetMaterial(svgdata.mat)
	surface.DrawTexturedRect(x, y, svgdata.w, svgdata.h)
end