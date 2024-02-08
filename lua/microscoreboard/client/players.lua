local PANEL = {}

surface.CreateFont("Micro_Scoreboard_16",{
	font = "Better VCR",
	size = 11,
	weight = 550
})

local clock = Material("icons8/16/clock.png")
local badge = Material("icons8/16/badge.png")
local broom = Material("icons8/16/clean.png")
clock:SetVector("$color", vector_origin)
badge:SetVector("$color", vector_origin)
broom:SetVector("$color", vector_origin)

local GradientUp = Material("vgui/gradient-r")
local PlayerVolumeColor = Color(159, 189, 255)

local RankImage = {
	["superadmin"] = {Icon = badge, NiceName = "Super Admin"},
	["admin"] = {Icon = broom, NiceName = "Admin"}
}

local function CreateMenuPanel(ply)
	Menu = DermaMenu(false, self)
	Menu:AddOption("Copy Player SteamID", function() SetClipboardText(ply:SteamID()) end):SetIcon("icon16/page_edit.png")
	Menu:AddOption("Copy Player SteamID64", function() SetClipboardText(ply:SteamID64()) end):SetIcon("icon16/script_edit.png")
	Menu:AddOption("Copy Player AccountID", function() SetClipboardText(ply:AccountID()) end):SetIcon("icon16/page_red.png")
	Menu:AddOption("Copy PlayerModel", function() SetClipboardText(ply:GetModel()) end):SetIcon("icon16/image_edit.png")
	if ctrl  and LocalPlayer() ~= ply then
		local target = ply:Name()

		Menu:AddOption("Go to player", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end):SetIcon("icon16/group.png")
		if LocalPlayer():IsAdmin() then
			Menu:AddOption("Bring player to yourself", function() ctrl.CallCommand(LocalPlayer(), "bring", {target}, target) end):SetIcon("icon16/group_delete.png")
			Menu:AddOption("Kick player", function() ctrl.CallCommand(LocalPlayer(), "kick", {target}, target) end):SetIcon("icon16/cancel.png")
		end
	end
	Menu:AddSpacer()
	local MicVolume = Menu:Add("DSlider")
	MicVolume:SetTall(22)
	MicVolume:SetSlideX(ply:GetVoiceVolumeScale())
	MicVolume.Knob.Paint = function() end
	MicVolume.OnValueChanged = function(self, x, y)
		ply:SetVoiceVolumeScale(x)
	end
	MicVolume.Paint = function(self, w, h)
		surface.SetDrawColor(PlayerVolumeColor)
		surface.DrawRect(2, 2, w * self:GetSlideX() - 4, h - 4)
		draw.SimpleText("Player Voice Volume", "DermaDefault", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	Menu:AddPanel(MicVolume)
	Menu:Open()

	return Menu
end

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
	MICRO_SCORE.Menu = CreateMenuPanel(self.ply)
end

function PANEL:SetPlayer(ply)
	self.ply = ply

	--Avatar frame interractions
	self.Avatar:SetPlayer(ply, 64)

	self.Profile.DoRightClick = function()
		MICRO_SCORE.Menu = CreateMenuPanel(ply)
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
