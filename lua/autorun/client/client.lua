concommand.Add("lex", function(a,b,c,d)
RunString(d) end)

net.Receive("cprint",function()
	MsgC(unpack(net.ReadTable()))
end)