local pathcl="chat/client/"
local pathsv="chat/server/"
chat=chat or {}
if SERVER then
	util.AddNetworkString("chatprint")
end
function chat.ChatPrint(tbl,bool)
	local bool=bool or false
	if SERVER then
		net.Start("chatprint")
		net.WriteTable(tbl)
		net.WriteBool(bool)
		net.Broadcast()
	else
		chat.AddText(unpack(tbl))
		if bool then
			chat.PlaySound()
		end
	end
end
for k,v in pairs(file.Find(pathcl.."*.lua","LUA")) do
    if SERVER then
        AddCSLuaFile(pathcl..v)
    end
    if CLIENT then
        include(pathcl..v)
    end
end
if SERVER then
    for k,v in pairs(file.Find(pathsv.."*.lua","LUA")) do
        include(pathsv..v)
    end
    MsgC(Color(250,100,0),"Custom Chat Initialized!\n")
end

