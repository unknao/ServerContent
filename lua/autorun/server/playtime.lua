local playtime = {}
string.gsub(file.Read("playtime.txt","DATA"),"[^\n]+",function(s)
    local tbl=string.Explode(" ",s)
    playtime[tbl[1]]=tbl[2]
end)
hook.Add("PlayerInitialSpawn","sv_playtime",function(ply)
    if ply:IsBot() then return end
    if playtime[ply:SteamID()]==nil then playtime[ply:SteamID()]=0  end
	ply:SetNWString("sv_playtime",math.floor(playtime[ply:SteamID()]/3600).."h")
end)
timer.Create("sv_playtime",60,0,function()
    for k,v in pairs(player.GetHumans()) do
        playtime[v:SteamID()] = playtime[v:SteamID()]+60
        v:SetNWString("sv_playtime",math.floor(playtime[v:SteamID()]/3600).."h")
    end
    local str=""
    for k,v in pairs(playtime)do
        str=str..k.." "..v.."\n"
    end
    file.Write("playtime.txt",str)
end)
