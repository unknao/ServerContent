local PANEL = {}

surface.CreateFont("Micro_Scoreboard_16",{
	font = "Better VCR",
	size = 11,
	weight = 550
})

local Clock_SVG = svg.Generate("MS_Clock", 14, 14, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 426.667 426.667" style="enable-background:new 0 0 426.667 426.667;" xml:space="preserve"><g><g><path d="M213.227,0C95.36,0,0,95.467,0,213.333s95.36,213.333,213.227,213.333s213.44-95.467,213.44-213.333S331.093,0,213.227,0z M213.333,384c-94.293,0-170.667-76.373-170.667-170.667S119.04,42.667,213.333,42.667S384,119.04,384,213.333 S307.627,384,213.333,384z"/></g></g><g><g><polygon points="224,218.667 224,106.667 192,106.667 192,234.667 303.893,301.867 320,275.627 "/></g></g></svg>]])
local GradientUp = Material("vgui/gradient-r")
local PlayerVolumeColor = Color(159, 189, 255)

local RankImage = {
	["superadmin"] = {
		Icon = svg.Generate("MS_Badge", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg id="Capa_1" enable-background="new 0 0 509.385 509.385" viewBox="0 0 509.385 509.385" xmlns="http://www.w3.org/2000/svg"><g><path d="m443.692 189c0-20.973-19.938-35.404-22.406-44.636-2.682-10.04 7.477-31.958-2.9-49.894-10.373-17.929-34.75-20.381-41.768-27.396-7.01-7.013-9.471-31.398-27.396-41.769-17.967-10.395-39.834-.207-49.894-2.9-9.241-2.47-23.652-22.405-44.636-22.405-20.973 0-35.404 19.938-44.636 22.406-10.039 2.682-31.961-7.477-49.894 2.9-17.929 10.373-20.381 34.75-27.396 41.768-7.013 7.01-31.397 9.471-41.769 27.396-10.363 17.913-.225 39.878-2.9 49.894-2.471 9.241-22.406 23.652-22.406 44.636 0 20.973 19.938 35.404 22.406 44.636 2.682 10.04-7.477 31.958 2.9 49.894 10.373 17.929 34.75 20.381 41.768 27.396 5.007 5.009 8.386 21.193 16.926 32.372v166.088l105-43.167 105 43.167v-166.09c8.445-11.054 11.922-27.363 16.925-32.369 7.013-7.01 31.398-9.471 41.769-27.397 10.363-17.913.225-39.878 2.9-49.894 2.472-9.241 22.407-23.653 22.407-44.636zm-264 168.468c11.422.036 24.352-3.482 30.364-1.874 6.501 1.738 16.912 13.392 29.636 19.036v65.319l-60 24.666zm90 82.481v-65.319c12.489-5.54 23.27-17.334 29.636-19.036 6.02-1.612 18.888 1.91 30.364 1.874v107.147zm135.61-236.764c-4.981 6.486-10.628 13.838-12.998 22.705-2.446 9.151-1.232 18.542-.162 26.827.725 5.612 1.718 13.298.277 15.789-1.518 2.623-8.469 5.504-14.054 7.818-7.662 3.175-16.347 6.773-22.961 13.389-6.615 6.615-10.214 15.299-13.389 22.961-2.314 5.585-5.195 12.535-7.817 14.053-2.489 1.441-10.176.447-15.789-.277-8.284-1.07-17.677-2.284-26.827.162-8.867 2.37-16.219 8.017-22.705 12.998-4.867 3.738-10.924 8.391-14.185 8.391s-9.317-4.652-14.185-8.391c-11.802-9.064-19.822-14.426-34.55-14.426-11.293 0-26.752 3.871-30.771 1.543-2.623-1.518-5.504-8.469-7.818-14.054-3.175-7.662-6.773-16.347-13.389-22.961-6.615-6.615-15.299-10.214-22.961-13.389-5.585-2.314-12.535-5.195-14.053-7.817-1.44-2.491-.447-10.177.277-15.789 1.07-8.285 2.284-17.676-.162-26.827-2.37-8.867-8.017-16.219-12.998-22.705-3.738-4.867-8.391-10.924-8.391-14.185s4.652-9.317 8.391-14.185c4.981-6.486 10.628-13.838 12.998-22.705 2.446-9.151 1.232-18.542.162-26.827-.725-5.612-1.718-13.298-.277-15.789 1.518-2.623 8.469-5.504 14.054-7.818 7.662-3.175 16.347-6.773 22.961-13.389 6.615-6.615 10.214-15.299 13.389-22.961 2.314-5.585 5.195-12.535 7.817-14.053 2.49-1.44 10.176-.447 15.789.277 8.283 1.069 17.675 2.282 26.827-.162 8.867-2.37 16.219-8.017 22.705-12.998 4.868-3.738 10.925-8.39 14.185-8.39s9.317 4.652 14.185 8.391c6.486 4.982 13.838 10.628 22.705 12.998 9.152 2.446 18.542 1.232 26.827.162 5.613-.725 13.3-1.719 15.789-.277 2.623 1.518 5.504 8.469 7.818 14.054 3.175 7.662 6.773 16.347 13.389 22.961 6.615 6.615 15.299 10.214 22.961 13.389 5.585 2.314 12.535 5.195 14.053 7.817 1.44 2.491.447 10.177-.277 15.789-1.07 8.285-2.284 17.676.162 26.827 2.37 8.867 8.017 16.219 12.998 22.705 3.738 4.867 8.391 10.924 8.391 14.185s-4.653 9.316-8.391 14.184z"/><path d="m254.692 84c-57.897 0-105 47.102-105 105s47.103 105 105 105 105-47.102 105-105-47.102-105-105-105zm0 180c-41.355 0-75-33.645-75-75s33.645-75 75-75 75 33.645 75 75-33.644 75-75 75z"/></g></svg>]]),
		NiceName = "Super Admin"
	},
	["admin"] = {
		Icon = svg.Generate("MS_Broom", 16, 16, [[<!-- icon666.com - MILLIONS vector ICONS FREE --><svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512.011 512.011" style="enable-background:new 0 0 512.011 512.011;" xml:space="preserve"><g><g><path d="M366.95,290.122H127.993c-4.711,0-8.534,3.823-8.534,8.534v51.205c0,4.711,3.823,8.534,8.534,8.534H366.95 c4.711,0,8.534-3.815,8.534-8.534v-51.205C375.484,293.945,371.661,290.122,366.95,290.122z M358.416,341.327H136.527V307.19 h221.889V341.327z"/></g></g><g><g><path d="M384.018,238.917H110.924c-4.711,0-8.534,3.823-8.534,8.534v51.205c0,4.711,3.823,8.534,8.534,8.534h273.094 c4.711,0,8.534-3.815,8.534-8.534v-51.205C392.552,242.74,388.729,238.917,384.018,238.917z M375.484,290.122H119.458v-34.137 h256.026V290.122z"/></g></g><g><g><path d="M179.198,383.998c-4.711,0-8.534,3.823-8.534,8.534v101.335c-14.704-3.806-25.603-17.188-25.603-33.061V349.861 c0-4.711-3.823-8.534-8.534-8.534c-4.711,0-8.534,3.823-8.534,8.534v110.944c0,28.24,22.966,51.205,51.205,51.205 c4.711,0,8.534-3.815,8.534-8.534V392.532C187.732,387.821,183.909,383.998,179.198,383.998z"/></g></g><g><g><path d="M247.471,42.63c-18.826,0-34.137,15.31-34.137,34.137s15.31,34.137,34.137,34.137s34.137-15.31,34.137-34.137 S266.298,42.63,247.471,42.63z M247.471,93.835c-9.413,0-17.068-7.655-17.068-17.068s7.655-17.068,17.068-17.068 c9.413,0,17.068,7.655,17.068,17.068S256.884,93.835,247.471,93.835z"/></g></g><g><g><path d="M366.95,238.917c-37.644,0-68.273-30.629-68.273-68.273c0-13.16,1.715-25.961,5.086-38.062 c7.032-25.21,8.193-50.019,3.439-73.77c-0.068-0.333-0.145-0.657-0.256-0.981c0,0-1.707-5.206-2.697-7.877 c-5.359-20.013-17.572-36.134-33.394-44.224c-14.32-7.672-32.618-7.578-46.622-0.077c-15.976,8.167-28.18,24.297-33.539,44.301 c-0.99,2.671-2.697,7.877-2.697,7.877c-0.102,0.324-0.188,0.649-0.256,0.981c-4.745,23.751-3.593,48.568,3.439,73.77 c3.371,12.102,5.086,24.903,5.086,38.062c0,37.644-30.629,68.273-68.273,68.273c-4.711,0-8.534,3.823-8.534,8.534 s3.823,8.534,8.534,8.534H366.95c4.711,0,8.534-3.823,8.534-8.534S371.661,238.917,366.95,238.917z M179.146,238.917 c20.747-15.583,34.188-40.384,34.188-68.273c0-14.704-1.92-29.059-5.701-42.637c-6.264-22.419-7.348-44.395-3.243-65.338 c0.444-1.357,1.724-5.214,2.424-7.049c0.111-0.29,0.205-0.58,0.282-0.879c4.071-15.515,13.151-27.856,25.065-33.949 c9.422-5.052,21.062-5.129,30.791,0.077c11.76,6.008,20.841,18.357,24.911,33.864c0.077,0.299,0.171,0.589,0.282,0.879 c0.7,1.835,1.98,5.692,2.424,7.049c4.105,20.934,3.013,42.918-3.243,65.338c-3.789,13.586-5.709,27.932-5.709,42.645 c0,27.89,13.441,52.69,34.188,68.273H179.146z"/></g></g><g><g><path d="M256.005,494.942c-7.604,0-25.603-19.876-25.603-51.205v-93.876c0-4.711-3.823-8.534-8.534-8.534h-42.671 c-4.711,0-8.534,3.823-8.534,8.534v93.876c0,33.096,29.912,68.274,85.342,68.274c4.711,0,8.534-3.823,8.534-8.534 C264.54,498.766,260.716,494.942,256.005,494.942z M187.732,443.737v-85.342h25.603v85.342c0,18.255,5.163,34.563,12.707,46.656 C200.789,481.885,187.732,462.726,187.732,443.737z"/></g></g><g><g><path d="M315.745,435.203c-4.711,0-8.534,3.823-8.534,8.534v17.068c0,4.711,3.823,8.534,8.534,8.534s8.534-3.815,8.534-8.534 v-17.068C324.279,439.026,320.456,435.203,315.745,435.203z"/></g></g><g><g><path d="M358.416,494.942h-102.41c-8.355,0-25.603-12.52-25.603-51.205v-85.342h76.808v34.137c0,4.711,3.823,8.534,8.534,8.534 s8.534-3.823,8.534-8.534v-42.671c0-4.711-3.823-8.534-8.534-8.534h-93.876c-4.711,0-8.534,3.823-8.534,8.534v93.876 c0,50.096,25.517,68.274,42.671,68.274h102.41c4.711,0,8.534-3.823,8.534-8.534C366.95,498.766,363.126,494.942,358.416,494.942z" /></g></g><g><g><path d="M273.074,341.327c-4.711,0-8.534,3.823-8.534,8.534v34.137c0,4.711,3.823,8.534,8.534,8.534s8.534-3.815,8.534-8.534 v-34.137C281.608,345.15,277.785,341.327,273.074,341.327z"/></g></g><g><g><path d="M273.074,418.135c-4.711,0-8.534,3.823-8.534,8.534v76.808c0,4.711,3.823,8.534,8.534,8.534s8.534-3.815,8.534-8.534 v-76.808C281.608,421.958,277.785,418.135,273.074,418.135z"/></g></g><g><g><path d="M401.087,494.942c-18.826,0-34.137-15.31-34.137-34.137V349.861c0-4.711-3.823-8.534-8.534-8.534h-59.739 c-4.711,0-8.534,3.823-8.534,8.534c0,4.711,3.823,8.534,8.534,8.534h51.205v102.41c0,13.1,4.95,25.073,13.074,34.137h-4.54 c-18.826,0-34.137-15.31-34.137-34.137c0-4.711-3.823-8.534-8.534-8.534s-8.534,3.823-8.534,8.534 c0,28.24,22.965,51.205,51.205,51.205h42.671c4.711,0,8.534-3.823,8.534-8.534C409.621,498.766,405.797,494.942,401.087,494.942z" /></g></g></svg>]]),
		NiceName = "Admin"
	}
}

local function CreateMenuPanel(ply)
	Menu = DermaMenu(false)
	Menu:AddOption("Copy Name", function() SetClipboardText(ply:Name()) end):SetIcon("icon16/image_edit.png")
	Menu:AddOption("Copy Profile URL", function() SetClipboardText("http://steamcommunity.com/profiles/" .. ply:SteamID64()) end):SetIcon("icon16/image_edit.png")
	Menu:AddOption("Copy Model", function() SetClipboardText(ply:GetModel()) end):SetIcon("icon16/image_edit.png")
	Menu:AddSpacer()

	Menu:AddOption("Copy SteamID", function() SetClipboardText(ply:SteamID()) end):SetIcon("icon16/page_edit.png")
	Menu:AddOption("Copy SteamID64", function() SetClipboardText(ply:SteamID64()) end):SetIcon("icon16/script_edit.png")
	Menu:AddOption("Copy AccountID", function() SetClipboardText(ply:AccountID()) end):SetIcon("icon16/page_red.png")
	if ctrl and LocalPlayer() ~= ply then
		Menu:AddSpacer()
		local target = ply:Name()


		if LocalPlayer():IsAdmin() then
			local SubMenu, ParentMenu = Menu:AddSubMenu("Go To", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end)
			ParentMenu:SetIcon("icon16/arrow_out.png")
			SubMenu:AddOption("Bring", function() ctrl.CallCommand(LocalPlayer(), "bring", {target}, target) end):SetIcon("icon16/arrow_in.png")

			Menu:AddOption("Kick", function() ctrl.CallCommand(LocalPlayer(), "kick", {target}, target) end):SetIcon("icon16/cancel.png")
		else
			Menu:AddOption("Go To", function() ctrl.CallCommand(LocalPlayer(), "goto", {target}, target) end):SetIcon("icon16/group.png")
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

	self.Rank = self:Add("DButton")
	self.Rank:SetText("")
	self.Rank:SetSize(16, 16)
	self.Rank:DockMargin(2, 2, 0, 2)
	self.Rank:Dock(LEFT)
	self.Rank:SetTooltip(Rank.NiceName)
	self.Rank:SetTooltipPanelOverride("MS_Tooltip")
	self.Rank.Paint = function()
		RankImage[ply:GetUserGroup()]["Icon"](0, 0)
	end

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

	local timeout
	if not ply:IsBot() then timeout = ply:nw3GetBool("IsTimingOut") end
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

	Clock_SVG(w - 76, 3)
	--[[surface.SetMaterial(clock)
	surface.SetDrawColor(color_black)
	surface.DrawTexturedRect(w - 78, 2, 16, 16)]]
end

vgui.Register("MS_PlayerInfo", PANEL, "DButton")
