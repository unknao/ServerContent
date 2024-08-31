local onyxhud_element_color = CreateConVar("onyxhud_element_color", "255 238 0 255", {FCVAR_ARCHIVE}, "Determines the color of the hud elements")
local onyxhud_enabled = CreateConVar("onyxhud_enabled", "1", {FCVAR_ARCHIVE}, "Determines whether onyxhud draws or not")
local color_background = Color(0, 0, 0, 90)
local color_element = Color(255, 238, 0)

cvars.AddChangeCallback("onyxhud_element_color", function(_, _, new)
	color_element = string.ToColor(new)
end)

surface.CreateFont("onyxhud_element_name", {
	font = "Mieghommel",
	size = 20,
	weight = 800,
})
surface.CreateFont("onyxhud_element_number", {
	font = "Mieghommel",
	size = 54,
	weight = 560,
	extended = true
})
surface.CreateFont("onyxhud_element_number2", {
	font = "Mieghommel",
	size = 24,
	weight = 560,
	extended = true
})

svg.Generate("onyxhud_flashlight", 50, 50, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 297 297" style="enable-background:new 0 0 297 297;" xml:space="preserve"><g><path d="M252.476,54.418c2.532,0,5.064-0.967,6.996-2.897l11.543-11.543c3.864-3.864,3.864-10.129,0-13.992 c-3.864-3.863-10.127-3.863-13.992,0L245.48,37.529c-3.863,3.863-3.863,10.128,0,13.992 C247.412,53.452,249.943,54.418,252.476,54.418z" fill="#000000" style="fill: rgb(255, 255, 255);"></path><path d="M208.668,23.037c0.292,5.269,4.656,9.345,9.869,9.345c0.185,0,0.371-0.005,0.558-0.016 c5.456-0.302,9.633-4.971,9.329-10.427l-0.699-12.593c-0.304-5.455-4.975-9.648-10.427-9.329c-5.456,0.302-9.633,4.971-9.33,10.427 L208.668,23.037z" fill="#000000" style="fill: rgb(255, 255, 255);"></path><path d="M287.654,69.276l-12.593-0.699c-5.453-0.305-10.125,3.874-10.427,9.329c-0.304,5.456,3.873,10.125,9.329,10.427l12.593,0.7 c0.186,0.01,0.373,0.015,0.558,0.015c5.213,0,9.577-4.076,9.869-9.345C297.287,74.247,293.11,69.579,287.654,69.276z" fill="#000000" style="fill: rgb(255, 255, 255);"></path><path d="M51.521,294.102l121.364-121.366c3.5-3.5,3.501-9.228,0-12.728l-35.893-35.894c-3.501-3.501-9.228-3.5-12.729,0 l-10.481,10.482l-4.547-4.547c-1.854-1.856-4.372-2.898-6.996-2.898c-2.624,0-5.141,1.042-6.996,2.897l-23.202,23.204 c-3.864,3.863-3.864,10.128,0,13.992l4.547,4.547L2.899,245.48c-3.864,3.864-3.864,10.129,0,13.992l34.63,34.63 c1.932,1.932,4.464,2.898,6.996,2.898S49.588,296.034,51.521,294.102z" fill="#000000" style="fill: rgb(255, 255, 255);"></path><path d="M141.439,98.38c-0.972,4.854,1.099,11.689,4.599,15.189l37.393,37.394c3.501,3.501,10.336,5.57,15.189,4.6l34.043-6.81 c4.854-0.971,5.962-4.629,2.461-8.129l-78.747-78.747c-3.5-3.501-7.158-2.393-8.13,2.461L141.439,98.38z" fill="#000000" style="fill: rgb(255, 255, 255);"></path><path d="M270.84,120.955c1.855-1.856,2.897-4.372,2.897-6.996s-1.042-5.14-2.897-6.996l-80.802-80.802 c-3.865-3.863-10.128-3.863-13.992,0l-11.533,11.533c-3.501,3.501-3.501,9.228,0,12.729l82.065,82.065c3.5,3.5,9.228,3.5,12.728,0 L270.84,120.955z" fill="#000000" style="fill: rgb(255, 255, 255);"></path></g></svg>]])
svg.Generate("onyxhud_onfire", 50, 50, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" xmlns:xlink="http://www.w3.org/1999/xlink" enable-background="new 0 0 512 512"><path d="m371.156,111.07c-7.891-12.656-23.469-18.188-37.578-13.328-14.102,4.859-22.977,18.813-21.398,33.641 2.969,27.883-1.789,48.516-15.656,65.242-29.563-33.797-39.734-81.266-25.156-124.984 2.578-7.727 5.977-15.242 10.383-22.984 6.234-10.953 4.852-25.375-2.586-35.555-6.024-8.227-15.61-13.094-25.813-13.102-0.008,0-0.008,0-0.016,0-10.195,0-19.773,4.859-25.805,13.078-15.922,21.703-155.531,215.211-155.531,324.383 0,96.242 81.344,174.539 181.336,174.539 101.18,0 186.664-79.93 186.664-174.539 0-71.531-26.383-158.273-68.844-226.391zm-116.866,368.927c-52.859,0-95.719-34.18-95.719-76.359 0-45.28 65.93-128.114 88.354-154.98 2.168-2.597 6.99-1.235 6.919,1.931-0.274,12.249-0.018,33.315 3.709,53.406 3.686,19.877 10.77,38.799 24.094,47.285 21.196-12.284 30.563-27.965 31.355-47.264 0.133-3.224 5.234-4.412 7.079-1.579 22.143,34.013 33.347,72.368 33.347,101.201 0.001,42.179-46.277,76.359-99.138,76.359z" fill="#000000" style="fill: rgb(255, 255, 255);"></path></svg>]])

local height, width = 60, 180
local function DrawElement(name, value, maxvalue, x, y)
	draw.RoundedBox(10, x, y - height, width, height, color_background)
	local bar_height = (height - 10) * 0.1
	local bar_width = (width - 10)
	local value_scale = math.min(value / maxvalue, 1)
	draw.RoundedBox(5, x + 5, y - 5 - bar_height, bar_width * value_scale, bar_height, color_element)
	if value > 999 then value = "999+" end

	local text_width = 10
	draw.SimpleText(name, "onyxhud_element_name", x + text_width, y - 10 - bar_height, color_element, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(value, "onyxhud_element_number", x + width - 10, y - 5, color_element, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end

local function DrawAmmoElement(name, value, maxvalue, value2, x, y)
	draw.RoundedBox(10, x, y - height, width, height, color_background)
	local bar_height = (height - 10) * 0.1
	local bar_width = (width - 10)
	local value_scale = math.min(value / maxvalue, 1)
	draw.RoundedBox(5, x + 5, y - 5 - bar_height, bar_width * value_scale, bar_height, color_element)

	local text_width = 10
	if value > 100 then name = name[1] .. ".." end
	draw.SimpleText(name, "onyxhud_element_name", x + text_width, y - 10 - bar_height, color_element, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	if maxvalue <= 0 then
		draw.SimpleText(value2, "onyxhud_element_number", x + width - 10, y - 5, color_element, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		return
	end
	local clip_width = width - 60
	draw.SimpleText(value, "onyxhud_element_number", x + clip_width, y - 5, color_element, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

	draw.SimpleText("\\" .. value2, "onyxhud_element_number2", x + clip_width, y - height + 5, color_element, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

local function DrawIcon(name, x, y)
	draw.RoundedBox(10, x, y - height, height, height, color_background)
	svg.Draw(name, x + 5, y - height + 5, color_element)
end

local ailments = {
	[1] = function() if LocalPlayer():FlashlightIsOn() then return "onyxhud_flashlight" end end,
	[2] = function() if LocalPlayer():IsOnFire() then return "onyxhud_onfire" end end
}

local health, armor, ply = 0, 0, LocalPlayer()
hook.Add("InitPostEntity", "testhud", function()
	ply = LocalPlayer()
	health, armor = ply:Health(), ply:Armor()
end)

hook.Add("HUDPaint", "testhud", function()
	if not onyxhud_enabled:GetBool() then return end
	if not IsValid(ply) then return end
	if ply:InVehicle() then return end
	if not ply:Alive() then return end

	health = health + (ply:Health() - health) * FrameTime() * 15
	DrawElement("HEALTH", math.max(math.Round(health), 0), ply:GetMaxHealth(), 25, ScrH() - 20)
	local icon_padding = 35 + width

	armor = armor + (ply:Armor() - armor) * FrameTime() * 15
	if math.Round(armor) > 0 then
		DrawElement("SUIT", math.Round(armor), ply:GetMaxArmor(), icon_padding, ScrH() - 20)
		icon_padding = icon_padding + 10 + width
	end
	for _, func in ipairs(ailments) do
		local str = func()
		if str then
			DrawIcon(str, icon_padding, ScrH() - 20)
			icon_padding = icon_padding + 10 + height
		end
	end

	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end
	local ammo_reserve = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
	if wep:GetMaxClip1() > 0  or ammo_reserve > 0 then
		DrawAmmoElement("AMMO", wep:Clip1(), wep:GetMaxClip1(), ammo_reserve, ScrW() - 205, ScrH() - 20)
	end

	local ammo2_reserve = ply:GetAmmoCount(wep:GetSecondaryAmmoType())
	if wep:GetMaxClip2() > 0  or ammo2_reserve > 0 then
		DrawAmmoElement("ALT", wep:Clip2(), wep:GetMaxClip2(), ammo2_reserve, ScrW() - 205, ScrH() - 90)
	end
end)

local shoulddraw = {
	CHudHealth = false,
	CHudBattery = false,
	CHudAmmo = false,
	CHudSecondaryAmmo = false
}

hook.Add("HUDShouldDraw", "testhud", function(name)
	if not onyxhud_enabled:GetBool() then return end
	return shoulddraw[name]
end)