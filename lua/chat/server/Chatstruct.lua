hook.Add("PlayerSay","serverchat",function(ply,text)
	local str=ply:Name()..": "..text
	hook.Run("chatlog",str)
end)

