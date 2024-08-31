local tag = "onyxhud_killfeed"
local size = 23
surface.CreateFont(tag, {
	font = "Mieghommel",
	size = size,
	weight = 750,
	extended = true
})
local function KillTextToMarkup(atk, wpn, ply)
	if wpn:find("#HL2_") then wpn = language.GetPhrase(wpn) end
	local clr1, clr2, clr3 = GAMEMODE:GetTeamNumColor(atk:Team()), Color(255, 255, 255), GAMEMODE:GetTeamNumColor(ply:Team())

	local color1 = {markup.Color(clr1), markup.Color(Color(math.floor(clr1.r * 0.25), math.floor(clr1.g * 0.25), math.floor(clr1.b * 0.25)))}
	local color2 = {markup.Color(clr2), markup.Color(Color(math.floor(clr2.r * 0.25), math.floor(clr2.g * 0.25), math.floor(clr2.b * 0.25)))}
	local color3 = {markup.Color(clr3), markup.Color(Color(math.floor(clr3.r * 0.25), math.floor(clr3.g * 0.25), math.floor(clr3.b * 0.25)))}

	local tbl = {
		[1] = markup.Parse(string.format("<font=%s><colour=%s>%s<colour=%s> [%s] <colour=%s>%s", tag, color1[2], atk:Name(), color2[2], wpn, color3[2], ply:Name())),
		[2] = markup.Parse(string.format("<font=%s><colour=%s>%s<colour=%s> [%s] <colour=%s>%s", tag, color1[1], atk:Name(), color2[1], wpn, color3[1], ply:Name())),
		[3] = CurTime() + 4 --Time to live
	}
	return tbl
end

local onyxhud_killfeed_elements = {}

net.Receive("onyxhud_killfeed", function()
	local atk, inf, ply = net.ReadEntity(), net.ReadString(), net.ReadEntity()
	table.insert(onyxhud_killfeed_elements, KillTextToMarkup(atk, inf, ply))
end)
hook.Add("HUDPaint", tag, function()
	if not onyxhud_killfeed_elements then return end

	local fade = 0
	for i, mkup in ipairs(onyxhud_killfeed_elements) do
		if mkup[3] <= CurTime() then
			fade = fade + 1
			table.remove(onyxhud_killfeed_elements, i)
			continue
		end
		fade = fade + 1 - math.min(math.ease.InOutCubic(mkup[3] - CurTime()), 1)
		for padding = 0, 1 do
			mkup[padding + 1]:Draw( ScrW() - 5 - 2 * padding, 5 - 2 * padding + (size + 3) * (i - 1 - fade), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, math.min(math.ease.InOutCubic(mkup[3] - CurTime()), 1) *255, TEXT_ALIGN_RIGHT)
		end
	end
end)

