local PANEL = {}
require("nw3")

surface.CreateFont("Micro_Scoreboard_16",{
	font = "HudHintTextLarge",
	size = 16,
	antialias = true
})

local RankImage = {
	["superadmin"] = {Icon = "icon16/shield.png", NiceName = "Super Admin"},
	["admin"] = {Icon = "icon16/award_star_bronze_1.png", NiceName = "Admin"}
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

	self.Profile.DoClick = function() self.ply:ShowProfile() end
	self.ProfileTooltip = self.Profile:Add("MS_TooltipImage")
	self.ProfileTooltip:SetPlayer(self.ply)
	self.Profile:SetTooltipPanel(self.ProfileTooltip)

	if ply:IsBot() then return end
	self.Flag = self:Add("DImageButton")
	self.Flag:SetSize(16, 12)
	self.Flag:DockMargin(0, 4, 42, 4)
	self.Flag:Dock(RIGHT)
	self.Flag:SetImage("flags16/" .. ply:nw3GetString("country_code") .. ".png")
	self.Flag:SetDepressImage(false)
	self.Flag:SetTooltip(ply:nw3GetString("country", "N/A"))
	self.Flag:SetTooltipPanelOverride("MS_Tooltip")

	--Ranks
	local Rank = RankImage[ply:GetUserGroup()]
	if not Rank then return end

	self.Rank = self:Add("DImageButton")
	self.Rank:SetImage(Rank.Icon)
	self.Rank:SetDepressImage(false)
	self.Rank:SetSize(16, 16)
	self.Rank:DockMargin(2, 2, 0, 2)
	self.Rank:Dock(LEFT)
	self.Rank:SetTooltip(Rank.NiceName)
	self.Rank:SetTooltipPanelOverride("MS_Tooltip")

	self.RankPadding = 16
end

local clock = Material("icon16/time.png")
function PANEL:Paint(w, h)
	if not IsValid(self.ply) then
		self:Remove()
		MICRO_SCORE.Scoreboard:UpdateSize(player.GetCount())
		return
	end

	local ply = self.ply
	local timeout = ply:GetNWBool("timeout")
	local color
	--Background Color
	for k ,v in pairs(self:GetChildren()) do
		local hover = v:IsHovered()
		self.Hovered = hover
		if hover then break end
	end

	self.Hovered = self:IsHovered() or self:IsChildHovered()
	if self.Hovered then
		color = timeout and MICRO_SCORE.Player_Timeout_BGColor_Hovered or MICRO_SCORE.Player_BGColor_Hovered
	else
		color = timeout and MICRO_SCORE.Player_Timeout_BGColor or MICRO_SCORE.Player_BGColor
	end

	surface.SetDrawColor(color)
	surface.DrawRect(0, 0, w, h)

	--Text
	draw.SimpleText(self.ply:Name(), "Micro_Scoreboard_16", 25 + self.RankPadding, 10, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.ply:IsBot() and "BOT" or self.ply:Ping(), "Micro_Scoreboard_16", w - 5, 10, MICRO_SCORE.Player_PingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	if self.ply:IsBot() then return end
	local playtime = self.ply:nw3GetInt("Playtime") + (RealTime() - self.ply:nw3GetInt("Joined"))

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

	surface.SetDrawColor(color_white)
	surface.SetMaterial(clock)
	surface.DrawTexturedRect(w - 78, 2, 16, 16)
end

vgui.Register("DPlayerInfo", PANEL, "DButton")
