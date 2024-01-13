require("slowhooks")

hook.Add("SlowTick","datastreamed",function()
	for _,v in pairs(player.GetAll()) do
		v:SetNWBool("timeout", v:IsTimingOut())
	end
end)