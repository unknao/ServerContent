local tag = "join_query"

if SERVER then
	require("finishedloading")
	util.AddNetworkString(tag)

	net.Receive(tag, function(_, ply)
		local str = net.ReadString():lower():Trim()
		timer.Stop(tag .. ply:SteamID64())

		if str ~= "multi-parent" then
			local reason = "Incorrectly answered the join question (" .. str .. ")."
			if str == nil or str == "" then
				reason = "Opted out of the join question."
			end
			ply:Kick(reason)
			return
		end

		PrintMessage(HUD_PRINTTALK, ply:Name() .. " has answered the join question.")
		ply:SetPData(tag, true)
	end)

	hook.Add("FinishedLoading", tag, function(ply)
		if ply:GetPData(tag) then return end

		net.Start(tag)
		net.Send(ply)
		timer.Create(tag .. ply:SteamID64(), 120, 1, function()
			ply:Kick("Failed to answer the join question in time.")
		end)
	end)
end

if not CLIENT then return end

net.Receive(tag, function()
	local D = vgui.Create("DFrame")
	D:SetSize(300, 75)
	D:SetTitle("Question time!")
	D:Center()
	D:SetDraggable(false)
	D:SetSizable(false)
	D:SetBackgroundBlur(true)
	D:SetDeleteOnClose(true)
	D.OnClose = function()
		net.Start(tag)
		net.SendToServer()
	end
	D:MakePopup()

	local L = vgui.Create("DLabel", D)
	L:SetText("What is the most important tool for building?")
	L:Dock(TOP)

	local E = vgui.Create("DTextEntry", D)
	E:SetPlaceholderText("Your answer here.")
	E:Dock(TOP)
	E.OnEnter = function(self)
		net.Start(tag)
		net.WriteString(self:GetValue())
		net.SendToServer()
		D:Remove()
	end
end)
