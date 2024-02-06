local PANEL = {}
require("nw3")

surface.CreateFont("Micro_Scoreboard_16",{
	font = "Better VCR",
	size = 11,
	weight = 550
})

local clock = Material("icons8/16/clock.png")
clock:SetVector("$color", vector_origin)
local badge = Material("icons8/16/badge.png")
badge:SetVector("$color", vector_origin)
local broom = Material("icons8/16/clean.png")
broom:SetVector("$color", vector_origin)

local GradientUp = Material("vgui/gradient-r")

local RankImage = {
	["superadmin"] = {Icon = badge, NiceName = "Super Admin"},
	["admin"] = {Icon = broom, NiceName = "Admin"}
}

function PANEL:Init()
	self:SetTall(20)
	self:SetText("")
	self:DockMargin(0, 0, 0, 3)
	self.LastClicked = UnPredictedCurTime()

	self.Avatar = self:Add("AvatarImage")
	self.Avatar:Dock(LEFT)
	self.Avatar:SetSize(20, 20)

	self.Profile = self.Avatar:Add("DButton")
	self.Profile:SetText("")
	self.Profile:Dock(FILL)
	self.Profile.Paint = nil
	self.Hovered = self:IsHovered() or self:IsChildHovered()

	self.RankPadding = 0
end

function PANEL:DoClick()
	if self.ply == LocalPlayer() then return end
	if not ctrl then return end

	local target = self.ply:Name()
	ctrl.CallCommand(LocalPlayer(), "goto", {target}, target)
end

function PANEL:DoRightClick()
	MICRO_SCORE.Menu = DermaMenu(false, self)
	MICRO_SCORE.Menu:AddOption("Copy Player SteamID", function() SetClipboardText(self.ply:SteamID()) end):SetIcon("icon16/user.png")
	MICRO_SCORE.Menu:AddOption("Copy Player SteamID64", function() SetClipboardText(self.ply:SteamID64()) end):SetIcon("icon16/user_suit.png")
	MICRO_SCORE.Menu:AddOption("Copy Player AccountID", function() SetClipboardText(self.ply:AccountID()) end):SetIcon("icon16/user_red.png")
	MICRO_SCORE.Menu:AddOption("Copy PlayerModel", function() SetClipboardText(self.ply:GetModel()) end):SetIcon("icon16/report_user.png")
	if ctrl  and LocalPlayer() ~= self.ply then
		local target = self.ply:Name()

		MICRO_SCORE.Menu:AddOption("Go to player", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end):SetIcon("icon16/flag_green.png")
		if LocalPlayer():IsAdmin() then
			MICRO_SCORE.Menu:AddOption("Bring player to yourself", function() ctrl.CallCommand(LocalPlayer(), "bring", {target}, target) end):SetIcon("icon16/flag_yellow.png")
			MICRO_SCORE.Menu:AddOption("Kick player", function() ctrl.CallCommand(LocalPlayer(), "kick", {target}, target) end):SetIcon("icon16/flag_red.png")
		end
	end
	MICRO_SCORE.Menu:Open()
end

function PANEL:SetPlayer(ply)
	self.ply = ply

	--Avatar frame interractions
	self.Avatar:SetPlayer(ply, 64)

	self.Profile.DoRightClick = function()
		MICRO_SCORE.Menu = DermaMenu(false, self)
		MICRO_SCORE.Menu:AddOption("Copy Player SteamID", function() SetClipboardText(self.ply:SteamID()) end):SetIcon("icon16/user.png")
		MICRO_SCORE.Menu:AddOption("Copy Player SteamID64", function() SetClipboardText(self.ply:SteamID64()) end):SetIcon("icon16/user_suit.png")
		MICRO_SCORE.Menu:AddOption("Copy Player AccountID", function() SetClipboardText(self.ply:AccountID()) end):SetIcon("icon16/user_red.png")
		MICRO_SCORE.Menu:AddOption("Copy PlayerModel", function() SetClipboardText(self.ply:GetModel()) end):SetIcon("icon16/report_user.png")
		if ctrl  and LocalPlayer() ~= self.ply then
			local target = self.ply:Name()

			MICRO_SCORE.Menu:AddOption("Go to player", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end):SetIcon("icon16/flag_green.png")
			if LocalPlayer():IsAdmin() then
				MICRO_SCORE.Menu:AddOption("Bring player to yourself", function() ctrl.CallCommand(LocalPlayer(), "bring", {target}, target) end):SetIcon("icon16/flag_yellow.png")
				MICRO_SCORE.Menu:AddOption("Kick player", function() ctrl.CallCommand(LocalPlayer(), "kick", {target}, target) end):SetIcon("icon16/flag_red.png")
			end
		end
		MICRO_SCORE.Menu:Open()
	end
	self.GradientColor = GAMEMODE:GetTeamColor(ply)
	self.GradientColor.a = 100

	self.Profile.DoClick = function() self.ply:ShowProfile() end
	self.ProfileTooltip = self.Profile:Add("MS_TooltipImage")
	self.ProfileTooltip:SetPlayer(self.ply)
	self.Profile:SetTooltipPanel(self.ProfileTooltip)

	if not ply:IsBot() then
		self.Flag = self:Add("DImageButton")
		self.Flag:SetSize(16, 12)
		self.Flag:DockMargin(0, 4, 42, 4)
		self.Flag:Dock(RIGHT)
		self.Flag:SetImage("flags16/" .. ply:nw3GetString("country_code") .. ".png")
		self.Flag:SetDepressImage(false)
		self.Flag:SetTooltip(ply:nw3GetString("country", "N/A"))
		self.Flag:SetTooltipPanelOverride("MS_Tooltip")
	end

	--Ranks
	local Rank = RankImage[ply:GetUserGroup()]
	if not Rank then return end

	self.Rank = self:Add("DImageButton")
	self.Rank:SetMaterial(Rank.Icon)
	self.Rank:SetDepressImage(false)
	self.Rank:SetSize(16, 16)
	self.Rank:DockMargin(2, 2, 0, 2)
	self.Rank:Dock(LEFT)
	self.Rank:SetTooltip(Rank.NiceName)
	self.Rank:SetTooltipPanelOverride("MS_Tooltip")

	self.RankPadding = 14
end

function PANEL:Paint(w, h)
	if not IsValid(self.ply) then
		self:Remove()
		MICRO_SCORE.Scoreboard:UpdateSize(player.GetCount())
		return
	end

	local ply = self.ply
	local color
	--Background Color
	for k ,v in pairs(self:GetChildren()) do
		local hover = v:IsHovered()
		self.Hovered = hover
		if hover then break end
	end

	if not ply:IsBot() then local timeout = ply:nw3GetBool("IsTimingOut") end
	self.Hovered = self:IsHovered() or self:IsChildHovered()
	surface.SetDrawColor(timeout and MICRO_SCORE.Player_Timeout_BGColor or MICRO_SCORE.Player_BGColor)
	surface.DrawRect(0, 0, w, h)

	if self.Hovered then
		surface.SetDrawColor(timeout and MICRO_SCORE.Player_Timeout_BGColor_Hovered or MICRO_SCORE.Player_BGColor_Hovered)
		surface.SetMaterial(GradientUp)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	--Text
	draw.SimpleText(ply:Name(), "Micro_Scoreboard_16", 25 + self.RankPadding, 10, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	draw.SimpleText(ply:IsBot() and "BOT" or ply:Ping(), "Micro_Scoreboard_16", w - 5, 10, MICRO_SCORE.Player_PingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	if ply:IsBot() then return end
	local playtime = ply:nw3GetInt("Playtime") + (RealTime() - ply:nw3GetInt("Joined"))

	local format = "h"
	if playtime < 3600 then
		playtime = math.floor(playtime / 60)
		format = "m"
	elseif playtime < 36000 then
		playtime = math.Round(playtime / 3600, 1)
	else
		playtime = math.floor(playtime / 3600)
	end
	draw.SimpleText(playtime .. format, "Micro_Scoreboard_16", w - 80, 10, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	surface.SetMaterial(clock)
	surface.SetDrawColor(color_black)
	surface.DrawTexturedRect(w - 78, 2, 16, 16)
end

vgui.Register("DPlayerInfo", PANEL, "DButton")
