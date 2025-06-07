hook.Add("OnPlayerChat","fakechat",function(ply, strText)
	chat.PlaySound()
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


