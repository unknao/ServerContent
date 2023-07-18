hook.Add("OnPlayerChat","fakechat",function(ply, strText)
	
	if ply == NULL then return end
	chat.AddText(GAMEMODE:GetTeamColor(ply),ply:Name(),Color(255,255,255),": ",strText)
	chat.PlaySound()
	return true
	
end)

hook.Add("ChatText","hide_joinleave",function( index, name, text, typ )
	if typ == "joinleave" then return true end
end)

net.Receive("chatprint", function()
	
	chat.AddText(unpack(net.ReadTable()))
	if net.ReadBool() then
		chat.PlaySound()
	end
	
end)


