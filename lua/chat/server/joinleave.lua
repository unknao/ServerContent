local tag="joinleave"
gameevent.Listen("player_connect")
local stilljoining={}
hook.Add("player_connect",tag,function(ply)
	if ply.bot==1 then return end
	stilljoining[ply.networkid]="Gave up connecting."
	local tbl={
		Color(230,230,100),
		"» ",
		Color(100,170,255),
		ply.name,
		Color(180,180,180),
		" ("..ply.networkid..") ",
		Color(100,170,255),
		"is connecting to the server."
	}
	chat.ChatPrint(tbl,true)
	local str=ply.name.." ("..ply.networkid..") ".."is connecting to the server."
	hook.Run("chatlog",str)
end)
gameevent.Listen("player_disconnect")
hook.Add("player_disconnect",tag, function(ply)
	if ply.bot==1 then return end
	ply.reason = ply.reason == "Disconnect by user." and stilljoining[ply.networkid] or ply.reason
	local tbl={
		Color(230,100,100),
		"« ",
		Color(180,50,50),
		ply.name,
		Color(180,180,180),
		" ("..ply.networkid..") ",
		Color(180,50,50),
		"has left the server. ("..ply.reason..")"
	}
	chat.ChatPrint(tbl,true)
	local str=ply.name.." ("..ply.networkid..") ".."has left the server. ("..ply.reason..")"
	hook.Run("chatlog",str)
end)
hook.Add("FinishedLoading",tag,function(ply)
	stilljoining[ply:SteamID()]=nil
	local tbl={
		Color(100,230,100),
		"♦ ",
		ply:GetPlayerColor():ToColor(),
		ply:Name(),
		Color(255,255,255),
		" has finished loading."
	}
	chat.ChatPrint(tbl,false)
	local str=ply:Name().. " has finished loading.\n"
	hook.Run("chatlog",str)
	MsgC(Color(100,255,100),"♦ ",Color(100,255,100),ply:Name().. " has finished loading.\n")
end)
