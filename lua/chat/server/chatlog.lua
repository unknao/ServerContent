local function chlog(str)
	if not file.Read("chatlog/"..os.date("%Y-%m-%d",os.time()).." chat.txt","DATA") then
		file.Write("chatlog/"..os.date("%Y-%m-%d",os.time()).." chat.txt","")
	end
	local time="["..os.date("%H:%M:%S",os.time()).."]"
	file.Append("chatlog/"..os.date("%Y-%m-%d",os.time()).." chat.txt",time..str.."\n")
end
hook.Add("chatlog","chatlog",function(str)
	if str==nil then return end
	chlog(str)
end)