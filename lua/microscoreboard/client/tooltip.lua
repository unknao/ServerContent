local TOOLTIPHELPER = {}
surface.CreateFont("MICRO_SCOREBOARDboard_14",{
	font = "HudHintTextLarge",
	size = 14,
	antialias = true
})
local cTooltipOutline = Color(60, 60 ,60)
function TOOLTIPHELPER:Init()
	self:SetFont("MICRO_SCOREBOARDboard_14")
	self:SetTextColor(cTooltipOutline)
end

function TOOLTIPHELPER:Paint(w, h)
	surface.SetDrawColor(MICRO_SCOREBOARD.Player_BGColor)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(cTooltipOutline)
	surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("MS_Tooltip", TOOLTIPHELPER, "DTooltip")

local TOOLTIPIMAGE = {}

function TOOLTIPIMAGE:Paint(w, h)
end

function TOOLTIPIMAGE:SetPlayer(ply)
	self.Image = self:Add("AvatarImage")
	self.Image:SetSize(186, 186)
	self.Image:SetPlayer(ply, 186)
	self:SetContents(self.Image, true)
end

vgui.Register("MS_TooltipImage", TOOLTIPIMAGE, "DTooltip")
