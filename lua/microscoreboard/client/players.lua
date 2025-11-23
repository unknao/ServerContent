local PANEL = {}

surface.CreateFont("micro_scoreboard_player_panel_16",{
	font = "Better VCR",
	size = 11,
	weight = 550
})

local gradient_up = Material("vgui/gradient-r")
local PlayerVolumeColor = Color(159, 189, 255)

local RankImage = {
	["superadmin"] = {
		Icon = "MS_Badge",
		Tooltip = "Supreme Overseer of Janitorial Staff"
	},
	["admin"] = {
		Icon = "MS_Broom",
		Tooltip = "Janitor"
	}
}

local function CreateMenuPanel(ply)
	Menu = DermaMenu(false)
	Menu:SetDeleteSelf(true)
	local CopySubMenu, CopyMenu = Menu:AddSubMenu("Copy")
	CopyMenu:SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy"))

	CopySubMenu:AddOption("Name", function() SetClipboardText(ply:Name()) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy_name"))
	CopySubMenu:AddOption("Profile URL", function() SetClipboardText("http://steamcommunity.com/profiles/" .. ply:SteamID64()) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy_button_profile_url"))
	CopySubMenu:AddOption("Model", function() SetClipboardText(ply:GetModel()) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy_model"))
	CopySubMenu:AddSpacer()
	CopySubMenu:AddOption("SteamID", function() SetClipboardText(ply:SteamID()) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy_steamid"))
	CopySubMenu:AddOption("SteamID64", function() SetClipboardText(ply:SteamID64()) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy_steamid64"))
	CopySubMenu:AddOption("AccountID", function() SetClipboardText(ply:AccountID()) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy_accountid"))
	CopySubMenu:AddOption("UserID", function() SetClipboardText(ply:EntIndex()) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_copy_userid"))

	if ctrl and LocalPlayer() ~= ply then
		Menu:AddSpacer()
		local target = ply:Name()


		if LocalPlayer():IsAdmin() then
			local SubMenu, ParentMenu = Menu:AddSubMenu("Go To", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end)
			ParentMenu:SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_goto"))
			SubMenu:AddOption("Bring", function() ctrl.CallCommand(LocalPlayer(), "bring", {target}, target) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_bring"))

			Menu:AddOption("Kick", function() ctrl.CallCommand(LocalPlayer(), "kick", {target}, target) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_kick"))
		else
			Menu:AddOption("Go To", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end):SetMaterial(svg.GetMaterial("micro_scoreboard_dmenu_goto"))
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
		draw.SimpleText("Voice Volume", "DermaDefault", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	Menu:AddPanel(MicVolume)
	Menu:Open()

	return Menu
end

local ms_player_panels = {}
local ms_player_panels_created = 0
function PANEL:Init()
	self:SetTall(20)
	self:SetText("")
	self:DockMargin(0, 0, 0, 3)
	self.lastClicked = UnPredictedCurTime()

	self.avatarPicture = self:Add("AvatarImage")
	self.avatarPicture:Dock(LEFT)
	self.avatarPicture:SetSize(20, 20)

	self.buttonProfile = self.avatarPicture:Add("DButton")
	self.buttonProfile:SetText("")
	self.buttonProfile:Dock(FILL)
	self.buttonProfile.Paint = nil
	self.hovered = self:IsHovered() or self:IsChildHovered()

	self.RankPadding = 0

	ms_player_panels_created = ms_player_panels_created + 1
	self.id = self:GetClassName() .. ms_player_panels_created
	ms_player_panels[self.id] = self
end

function PANEL:DoClick()
	if self.ply == LocalPlayer() then return end
	if not ctrl then return end

	local target = self.ply:Name()
	ctrl.CallCommand(LocalPlayer(), "goto", {target}, target)
end

function PANEL:DoRightClick()
	MICRO_SCOREBOARD.Menu = CreateMenuPanel(self.ply)
end

function PANEL:SetPlayer(ply)
	self.ply = ply

	self.avatarPicture:SetPlayer(ply, 64)

	self.buttonProfile.DoRightClick = function()
		MICRO_SCOREBOARD.Menu = CreateMenuPanel(ply)
	end

	self.buttonProfile.DoClick = function() self.ply:ShowProfile() end
	self.buttonProfileTooltip = self.buttonProfile:Add("MS_TooltipImage")
	self.buttonProfileTooltip:SetPlayer(self.ply)
	self.buttonProfile:SetTooltipPanel(self.buttonProfileTooltip)

	if not ply:IsBot() then
		self.Flag = self:Add("DImageButton")
		self.Flag:SetSize(16, 12)
		self.Flag:DockMargin(0, 4, 42, 4)
		self.Flag:Dock(RIGHT)
		self.Flag:SetImage("materials/flags16/" .. ply:nw3GetString("country_code") .. ".png")
		self.Flag:SetDepressImage(false)
		self.Flag:SetTooltip(ply:nw3GetString("country", "N/A"))
		self.Flag:SetTooltipPanelOverride("MS_Tooltip")
	end

	self:SetRank(self.ply:GetUserGroup())
	--Ranks
end

function PANEL:SetRank(rank)
	if not RankImage[rank] then
		if IsValid(self.Rank) then
			self.Rank:Remove()
			self.RankPadding = 0
		end
		return
	end
	rank = RankImage[rank]

	if IsValid(self.Rank) then
		self.Rank:SetTooltip(rank.Tooltip)
		self.Rank.Paint = function()
			svg.Draw(rank["Icon"], 0, 0)
		end
		return
	end
	self.Rank = self:Add("DButton")
	self.Rank:SetText("")
	self.Rank:SetSize(16, 16)
	self.Rank:DockMargin(2, 2, 0, 2)
	self.Rank:Dock(LEFT)
	self.Rank:SetTooltip(rank.Tooltip)
	self.Rank:SetTooltipPanelOverride("MS_Tooltip")
	self.Rank.Paint = function()
		svg.Draw(rank["Icon"], 0, 0)
	end

	self.RankPadding = 14
end

function PANEL:GetPlayerID()
	if not IsValid(self.ply) then return end

	return self.ply:EntIndex()
end

function PANEL:UpdateFlag(flag)
	self.Flag:SetImage("materials/flags16/" .. flag .. ".png")
end

function PANEL:UpdateCountryName(name)
	self.Flag:SetTooltip(name)
end

function PANEL:Paint(w, h)
	if not IsValid(self.ply) then
		self:Remove()
		MICRO_SCOREBOARD.Scoreboard:UpdateSize(player.GetCount())
		return
	end

	local ply = self.ply
	--Background Color
	for k ,v in pairs(self:GetChildren()) do
		local hover = v:IsHovered()
		self.hovered = hover
		if hover then break end
	end

	local timeout
	if not ply:IsBot() then timeout = ply:nw3GetBool("IsTimingOut") end

	self.hovered = self:IsHovered() or self:IsChildHovered()
	surface.SetDrawColor(timeout and MICRO_SCOREBOARD.Player_Timeout_BGColor or MICRO_SCOREBOARD.Player_BGColor)
	surface.DrawRect(0, 0, w, h)

	if self.hovered then
		surface.SetDrawColor(timeout and MICRO_SCOREBOARD.Player_Timeout_BGColor_Hovered or MICRO_SCOREBOARD.Player_BGColor_Hovered)
		surface.SetMaterial(gradient_up)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	--Text
	draw.SimpleText(ply:Name(), "micro_scoreboard_player_panel_16", 25 + self.RankPadding, 10, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	if ply:IsBot() then
		draw.SimpleText("BOT", "micro_scoreboard_player_panel_16", w - 5, 10, MICRO_SCOREBOARD.Player_PingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		return
	end
	local playtime = ply:nw3GetInt("Playtime") + (CurTime() - ply:nw3GetInt("Joined"))

	local format = "h"
	if playtime < 3600 then
		playtime = math.floor(playtime / 60)
		format = "m"
	elseif playtime < 36000 then
		playtime = math.Round(playtime / 3600, 1)
	else
		playtime = math.floor(playtime / 3600)
	end
	draw.SimpleText(playtime .. format, "micro_scoreboard_player_panel_16", w - 80, 10, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	svg.Draw("MS_Clock", w - 76, 3)

	if timeout then
		svg.Draw("MS_Timeout", w - 18, 3)
	else
		draw.SimpleText(ply:Ping(), "micro_scoreboard_player_panel_16", w - 5, 10, MICRO_SCOREBOARD.Player_PingColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end

function PANEL:OnRemove()
	ms_player_panels[self.id] = nil
end

hook.Add("OnNW3ReceivedEntityValue", "micro_scoreboard_flag_update", function(entindex, _, id, var)
	if id ~= "country" and id ~= "country_code" and id ~= "user_group" then return end
	print(id)

	for _, pnl in pairs(ms_player_panels) do
		if pnl:GetPlayerID() ~= entindex then continue end

		if id == "country_code" then
			pnl:UpdateFlag(var)
		elseif id == "country" then
			pnl:UpdateCountryName(var)
		elseif id == "user_group" then
			print("hi")
			pnl:SetRank(var)
		end
		break
	end
end)

vgui.Register("MS_PlayerInfo", PANEL, "DButton")
