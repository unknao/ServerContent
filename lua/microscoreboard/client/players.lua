local PANEL = {}

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
	self.Avatar:SetMouseInputEnabled(true)
	self.Avatar:SetSize(20, 20)

	self.Profile = self.Avatar:Add("DButton")
	self.Profile:SetText("")
	self.Profile:Dock(FILL)
	self.Profile.Paint = nil

	self.RankPadding = 0
end

function PANEL:SetPlayer(ply)
	self.ply = ply
	--Avatar frame interractions
	self.Avatar:SetPlayer(ply, 64)

	self.Profile.DoRightClick = function()
		local Menu = DermaMenu(false, self)
		Menu:AddOption("Copy Player SteamID", function() SetClipboardText(self.ply:SteamID()) end):SetIcon("icon16/user.png")
		Menu:AddOption("Copy Player SteamID64", function() SetClipboardText(self.ply:SteamID64()) end):SetIcon("icon16/user_suit.png")
		Menu:AddOption("Copy Player AccountID", function() SetClipboardText(self.ply:AccountID()) end):SetIcon("icon16/user_red.png")
		Menu:AddOption("Copy PlayerModel", function() SetClipboardText(self.ply:GetModel()) end):SetIcon("icon16/report_user.png")
		if ctrl  and LocalPlayer() ~= self.ply then
			local target = self.ply:Name()

			Menu:AddOption("Go to player", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end):SetIcon("icon16/flag_green.png")
			if LocalPlayer():IsAdmin() then
				Menu:AddOption("Bring player to yourself", function() ctrl.CallCommand(LocalPlayer(), "bring", {target}, target) end):SetIcon("icon16/flag_yellow.png")
				Menu:AddOption("Kick player", function() ctrl.CallCommand(LocalPlayer(), "kick", {target}, target) end):SetIcon("icon16/flag_red.png")
			end
		end
		Menu:Open()
	end
	if ply:IsBot() then return end
	self.Profile.DoClick = function() self.ply:ShowProfile() end

	self.Flag = self:Add("DImageButton")
	self.Flag:SetSize(16, 12)
	self.Flag:DockMargin(0, 4, 42, 4)
	self.Flag:Dock(RIGHT)
	self.Flag:SetImage("flags16/" .. ply:GetNWString("country_code") .. ".png")
	self.Flag:SetTooltip(ply:GetNWString("country", "N/A"))

	--Ranks
	local Rank = RankImage[ply:GetUserGroup()]
	if not Rank then return end

	self.Rank = self:Add("DImageButton")
	self.Rank:SetImage(Rank.Icon)
	self.Rank:SetSize(16, 16)
	self.Rank:DockMargin(2, 2, 0, 2)
	self.Rank:Dock(LEFT)
	self.Rank:SetTooltip(Rank.NiceName)
	self.RankPadding = 16
end

function PANEL:CreateFlag(CountryCode, CountryName)

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
	if self:IsHovered() then
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
	local playtime = self.ply:GetNWInt("Playtime") + (CurTime() - self.ply:GetNWInt("Joined"))
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
