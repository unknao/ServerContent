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

hook.Add("OnEntityCreated", tag, function()
	
	hook.Remove("OnEntityCreated", tag)
	loadingTable.time[3] = math.Round(SysTime() - loadingTable.time[3], 2)
	
	loadingTable.text[4] = "Player: "
	loadingTable.time[4] = SysTime()

end)

hook.Add("InitPostEntity", tag, function()
	
	hook.Remove("InitPostEntity", tag)
	loadingTable.time[4] = math.Round(SysTime() - loadingTable.time[4], 2)
	
	loadingTable.text[5] = "Render: "
	loadingTable.time[5] = SysTime()
	
end)

hook.Add("RenderScene", tag, function()
	
	hook.Remove("RenderScene", tag)
	loadingTable.time[5] = math.Round(SysTime() - loadingTable.time[5], 2)
	
	loadingTable.text[6] = "Think: "
	loadingTable.time[6] = SysTime()
	
end)

hook.Add("Think", tag, function()
	
	hook.Remove("Think", tag)
	loadingTable.time[6] = math.Round(SysTime() - loadingTable.time[6], 2)
	
	loadingTable.text[7] = "Fully Initialized!"
	
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
local dots = Material("icon16/bomb.png")
local people = Material("icon16/user.png")
local clock = Material("icon16/clock.png")

hook.Add("HUDShouldDraw", tag, function()
	
	hook.Remove("HUDShouldDraw", tag)
	
	timer.Create(tag, 3, 1, function()
		Start = 2
	end)
	
end)

local Alpha = 1

--Fire
local firecoord = {x = {}, y = {}, rot = {}}
local firetick = 0

for i = 1, 20 do
	
	firecoord.x[i], firecoord.y[i], firecoord.rot[i] = math.random(-65, 65), math.random(-20, 20), math.random(-10, 10)
	
end

local PseudoTimer = 0
local livetime
--Transition into lua loading screen
hook.Add("DrawOverlay", tag, function()

	--Don't draw the expensive one when its not needed
	if Start ~= nil then
	
		PseudoTimer = PseudoTimer + RealFrameTime()
		
		for i = 1, Width * Height do
		
			local Fraction = math.Clamp(Start - (0.0065359477124183 * i - 1) - PseudoTimer, 0, 1)
			surface.SetDrawColor(Color((1 - Fraction) * 255, (1 - Fraction) * 255, (1 - Fraction) * 255, 255 * Fraction))
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
	 
	surface.SetMaterial(glow)
	surface.SetDrawColor(235, 117, 77, 170 * Alpha)
	surface.DrawTexturedRectRotated(ScrW() / 2, ScrH()/ 2, 750, 750, RealTime() * 40)

	surface.SetMaterial(pc)
	surface.SetDrawColor(255, 124, 77, 255 * Alpha)
	surface.DrawTexturedRectRotated(ScrW() / 2 + math.random(-2, 2), ScrH()/ 2 + math.random(-2, 2), 128, 128, math.random(-1, 1))
		
	--Fire
	if firetick < RealTime() then --Timers don't cut it for this use case.
	
		for i = 1, 20 do
			firecoord.x[i], firecoord.y[i], firecoord.rot[i] = math.random(-65, 65), math.random(-20, 20), math.random(-10, 10)
		end
		
		firetick = RealTime() + 0.2
		
	end
	
	for i = 1, 20 do
	
		surface.SetMaterial(fire)
		surface.SetDrawColor(255, 255, 255, 255 * Alpha)
		surface.DrawTexturedRectRotated(ScrW() / 2 + firecoord.x[i], ScrH()/ 2+ firecoord.y[i] + 50, 70, 70, firecoord.rot[i])		
		
		surface.SetMaterial(glow)
		surface.SetDrawColor(235, 198, 77, 60 * Alpha)
		surface.DrawTexturedRectRotated(ScrW() / 2 + firecoord.x[i], ScrH()/ 2+ firecoord.y[i] + 50, 180, 180, firecoord.rot[i])
		
	end
	
	--Three dots
	surface.SetDrawColor(200, 200, 200, 255 * Alpha)
	surface.SetMaterial(dots)
	for i = 0, 2 do
		surface.DrawTexturedRect(ScrW() / 2 - 146 + 130 * i, ScrH() / 2 + 140 - math.max(math.sin(RealTime() * 5 + i * 20), 0) * 30, 32, 32)
	end
	
	--People surrounding
	surface.SetMaterial(people)
	for i = 0, 14 do
	
		local wave = 300 + math.sin(math.rad(RealTime() * 360 + i * 24)) * 9
		local x, y = ScrW() / 2 + math.sin(math.rad(RealTime() * 15 + i * 24)) * wave, ScrH()/ 2 + math.cos(math.rad(RealTime() * 15 + i * 24)) * wave
		
		surface.DrawTexturedRectRotated(x, y, 32, 32, RealTime() * 15 + i * 24 + 180)
		
	end
	
	--Loading text
	for i, v in ipairs(loadingTable.text) do
	
		draw.Text({
				text = v,
				font = tag,
				xalign = 2,
				yalign = 3,
				color = Color(230, 230 ,230, 255 * Alpha),
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
				color = Color(230, 230 ,230, 255 * Alpha),
				pos = {ScrW() / 2 - 400, ScrH() / 2 - 200 + 35 * i}
		})
		
	end
	
	if #loadingTable.text == 7 then
		surface.SetMaterial(clock)
		surface.DrawTexturedRectRotated(ScrW() / 2 - 380 + math.random(-2, 2), ScrH() / 2  + 58 + math.random(-2, 2), 26, 26, math.random(-8, 8))
	end
	
	--This is fine
	draw.Text({
			text = "This is fine.",
			font = "introfancy",
			xalign = 1,
			yalign = 1,
			color = Color(235, 195, 77, 255 * Alpha),
			pos = {ScrW() / 2, ScrH() / 2 - 150}
	})

end)
