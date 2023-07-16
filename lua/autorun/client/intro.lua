local tag = "serverintro"

surface.CreateFont("serverintro", {
	font = "Arial",
	outline = false,
	size = 50,
	weight = 2000,
	extended = true,
})

local decay = false
local FadeOut
local barsize = math.floor(ScrH() * 0.092592592592593) -- Scale to screen size	

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
local dots = Material("icon16/world.png")
local people = Material("icon16/user.png")

hook.Add("HUDPaint", tag, function()
	
	hook.Remove("HUDPaint", tag)
	timer.Create(tag, 1.5, 1, function()
		Start = CurTime() + 2
	end)
	
end)

local Alpha = 1
hook.Add("DrawOverlay", tag, function()

	--Don't draw the expensive one when its not needed
	if Start ~= nil then
		for i = 1, Width * Height do
		local Fraction = math.Clamp(Start - (0.0065359477124183 * i - 1) - CurTime(), 0, 1)
			surface.SetDrawColor(Color((1 - Fraction) * 255, (1 - Fraction) * 255, (1 - Fraction) * 255, 255 * Fraction))
			render.SetColorMaterial()
			surface.DrawRect(squares.w[i] - 1, squares.h[i] - 1, 121, 121)
		end
		Alpha = math.ease.OutCubic(math.Clamp(Start - CurTime(), 0, 1))
		if Start < CurTime() - 2 then hook.Remove("DrawOverlay", tag) end
	else
		surface.SetDrawColor( 0, 0, 0, 255 )
		render.SetColorMaterial()
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end
	
	surface.SetMaterial(pc)
	surface.SetDrawColor( 255, 255, 255, 255 * Alpha)
	surface.DrawTexturedRectRotated( ScrW() / 2, ScrH()/ 2, 128, 128, math.sin(RealTime() * 2) * 10)
	
	--Three dots
	surface.SetMaterial(dots)
	for i = 0, 2 do
		surface.DrawTexturedRect(ScrW() / 2 - 130 + 130 * i, ScrH() / 2 + 140 - math.max(math.sin(RealTime() * 5 + i * 20), 0) * 30, 32, 32)
	end
	
	--People surrounding
	surface.SetMaterial(people)
	for i = 0, 14 do
		local wave = 300 + math.sin(math.rad(RealTime() * 360 + i * 24)) * 9
		local x, y = ScrW() / 2 + math.sin(math.rad(RealTime() * 15 + i * 24)) * wave, ScrH()/ 2 + math.cos(math.rad(RealTime() * 15 + i * 24)) * wave
	surface.DrawTexturedRectRotated(x, y, 32, 32, RealTime() * 15 + i * 24 + 180)
	end

end)
