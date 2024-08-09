if SERVER then
	resource.AddSingleFile("resource/fonts/AGENCYR.ttf")
	resource.AddSingleFile("resource/fonts/ITCEDSCR.ttf")
	return
end

local tag = "serverintro"

surface.CreateFont(tag, {
	font = "Agency FB",
	outline = false,
	size = 30,
	weight = 2000,
	extended = true,
})

surface.CreateFont("introfancy", {
	font = "Edwardian Script ITC",
	outline = false,
	size = 80,
	weight = 100,
	extended = true,
})

--Load info

local loadingTable = {
	text = {},
	time = {}
}

hook.Add("PreGamemodeLoaded", tag, function()
	hook.Remove("PreGamemodeLoaded", tag)
	loadingTable.text[1] = "Gamemode: "
	loadingTable.time[1] = SysTime()
end)

hook.Add("Initialize", tag, function()
	hook.Remove("Initialize", tag)
	loadingTable.time[1] = math.Round(SysTime() - loadingTable.time[1], 2)
	loadingTable.text[2] = "Tick: "
	loadingTable.time[2] = SysTime()
end)

hook.Add("Tick", tag, function()
	hook.Remove("Tick", tag)
	loadingTable.time[2] = math.Round(SysTime() - loadingTable.time[2], 2)
	loadingTable.text[3] = "Entity: "
	loadingTable.time[3] = SysTime()
end)

hook.Add("InitPostEntity", tag, function()
	hook.Remove("InitPostEntity", tag)
	loadingTable.time[3] = math.Round(SysTime() - loadingTable.time[3], 2)
	loadingTable.text[4] = "Render: "
	loadingTable.time[4] = SysTime()
end)

hook.Add("RenderScene", tag, function()

	hook.Remove("RenderScene", tag)
	loadingTable.time[4] = math.Round(SysTime() - loadingTable.time[4], 2)
	loadingTable.text[5] = "Think: "
	loadingTable.time[5] = SysTime()
end)

hook.Add("Think", tag, function()

	hook.Remove("Think", tag)
	loadingTable.time[5] = math.Round(SysTime() - loadingTable.time[5], 2)
	loadingTable.text[6] = "Fully Initialized!"
end)

local Width = math.ceil(ScrW() / 120) + 1
local Height = math.ceil(ScrH() / 120)

local squares = {
	w = {},
	h = {}
}

for i = 1, Width * Height do
	squares.w[i] = ((i % Width) - 1) * 120
	squares.h[i] = math.floor(i / Width) * 120
end

local Start
local pc = Material("materials/icon16/computer.png")
local glow = Material("sprites/physg_glow1")
local fire = Material("icon16/fire.png")
local dots = Material("icon16/database.png")
local clock = Material("icon16/accept.png")

local people_skins = {
	[1] = Material("icon16/user_female.png"),
	[2] = Material("icon16/user.png"),
	[3] = Material("icon16/user_gray.png"),
	[4] = Material("icon16/user_green.png"),
	[5] = Material("icon16/user_orange.png"),
	[6] = Material("icon16/user_red.png"),
	[7] = Material("icon16/user_suit.png")
}
local people = {}
for i = 0, 20 do
	people[i] = table.Random(people_skins)
end

hook.Add("HUDShouldDraw", tag, function()
	hook.Remove("HUDShouldDraw", tag)
	timer.Create(tag, 3, 1, function()
		Start = 2
	end)
end)

--Fire
local firecoord = {x = {}, y = {}, rot = {}}
local firetick = 0

for i = 1, 20 do
	firecoord.x[i], firecoord.y[i], firecoord.rot[i] = math.random(-65, 65), math.random(-20, 20), math.random(-10, 10)
end

local Alpha = 1
local PseudoTimer = 0
local livetime

local text_color1, text_color2 = Color(230, 230 ,230, 255), Color(235, 195, 77, 255)
--Transition into lua loading screen
hook.Add("DrawOverlay", tag, function()
	--Don't draw the expensive one when its not needed
	if Start ~= nil then
		PseudoTimer = PseudoTimer + RealFrameTime()
		for i = 1, Width * Height do

			local Fraction = math.Clamp(Start - (0.0065359477124183 * i - 1) - PseudoTimer, 0, 1)
			surface.SetDrawColor((1 - Fraction) * 255, (1 - Fraction) * 255, (1 - Fraction) * 255, 255 * Fraction)
			render.SetColorMaterial()
			surface.DrawRect(squares.w[i] - 1, squares.h[i] - 1, 121, 121)

		end

		Alpha = math.ease.OutCubic(math.Clamp(Start - PseudoTimer, 0, 1))
		if Start < PseudoTimer - 2 then
			timer.Stop("serverintro.fire")
			hook.Remove("DrawOverlay", tag)
		end
	else
		surface.SetDrawColor(0, 0, 0, 255)
		render.SetColorMaterial()
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end

	surface.SetDrawColor(200, 200, 200, 255 * Alpha)
	for i = 11, 20 do
		surface.SetMaterial(people[i])

		local mul = math.rad(i * 18)
		local x, y = ScrW() / 2 + math.cos(mul) * 240, ScrH() / 2 + math.sin(mul) * 50 + 170 + math.cos(mul + SysTime() * 5) * 4
		local scale = 26 + 6 * math.sin(mul)

		surface.DrawTexturedRectRotated(x, y, scale, scale, math.sin(mul + SysTime() * 5) * 5)
	end

	surface.SetMaterial(glow)
	surface.SetDrawColor(235, 117, 77, 170 * Alpha)
	surface.DrawTexturedRectRotated(ScrW() / 2, ScrH() / 2, 750, 750, SysTime() * 40)

	surface.SetMaterial(pc)
	surface.SetDrawColor(255, 124, 77, 255 * Alpha)
	surface.DrawTexturedRectRotated(ScrW() / 2 + math.random(-2, 2), ScrH() / 2 + math.random(-2, 2), 128, 128, math.random(-1, 1))

	--Fire
	if firetick < SysTime() then --Timers don't run when CurTime() doesn't run
		for i = 1, 20 do
			firecoord.x[i], firecoord.y[i], firecoord.rot[i] = math.random(-65, 65), math.random(-20, 20), math.random(-10, 10)
		end
		firetick = SysTime() + 0.2
	end

	for i = 1, 20 do
		surface.SetMaterial(fire)
		surface.SetDrawColor(255, 255, 255, 255 * Alpha)
		surface.DrawTexturedRectRotated(ScrW() / 2 + firecoord.x[i], ScrH() / 2 + firecoord.y[i] + 50, 70, 70, firecoord.rot[i])

		surface.SetMaterial(glow)
		surface.SetDrawColor(235, 198, 77, 60 * Alpha)
		surface.DrawTexturedRectRotated(ScrW() / 2 + firecoord.x[i], ScrH() / 2 + firecoord.y[i] + 50, 180, 180, firecoord.rot[i])
	end

	--People surrounding
	surface.SetDrawColor(200, 200, 200, 255 * Alpha)
	for i = 0, 10 do
		surface.SetMaterial(people[i])

		local mul = math.rad(i * 18)
		local x, y = ScrW() / 2 + math.cos(mul) * 240, ScrH() / 2 + math.sin(mul) * 50 + 170 + math.cos(mul + SysTime() * 5) * 4
		local scale = 26 + 6 * math.sin(mul)

		surface.DrawTexturedRectRotated(x, y, scale, scale, math.sin(mul + SysTime() * 5) * 5)
	end

	--Three dots
	surface.SetMaterial(dots)
	for i = 0, 2 do
		surface.DrawTexturedRect(ScrW() / 2 - 146 + 130 * i, ScrH() / 2 + 140 - math.max(math.sin(SysTime() * 5 + i * 20), 0) * 30, 32, 32)
	end

	--Loading text
	for i, v in ipairs(loadingTable.text) do
		text_color1.a = 255 * Alpha
		draw.Text({
			text = v,
			font = tag,
			xalign = 2,
			yalign = 3,
			color = text_color1,
			pos = {ScrW() / 2 - 400, ScrH() / 2 - 200 + 35 * i}
		})

		if type(loadingTable.time[i]) == "number" then
			livetime = (i == #loadingTable.text) and math.Round(SysTime() - loadingTable.time[i], 2)  or loadingTable.time[i]
		else
			continue
		end

		draw.Text({
			text = livetime,
			font = tag,
			xalign = 0,
			yalign = 3,
			color = text_color1,
			pos = {ScrW() / 2 - 400, ScrH() / 2 - 200 + 35 * i}
		})
	end

	if #loadingTable.text == 6 then
		surface.SetMaterial(clock)
		surface.DrawTexturedRect(ScrW() / 2 - 390, ScrH() / 2  + 10, 26, 26)
	end

	--This is fine
	text_color2.a = 255 * Alpha
	draw.Text({
		text = "This is fine.",
		font = "introfancy",
		xalign = 1,
		yalign = 1,
		color = text_color2,
		pos = {ScrW() / 2, ScrH() / 2 - 150}
	})
end)
