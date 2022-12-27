local tag = "botcolor"

local clr = team.GetColor(3)
clr = Vector(clr.r / 255,clr.g / 255,clr.b / 255)

hook.Add("PlayerSpawn",tag,function(ply)
	if not ply:IsBot() then return end
	timer.Simple(0,function()
		ply:SetPlayerColor(clr)
		ply:SetWeaponColor(clr)
	end)
end)