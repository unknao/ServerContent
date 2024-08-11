require("canconstrainhook")
--Some constraints made on a large enough distance away from the prop itself kill the server instantly.
local tMaxSize = {
	Axis = 51380224,
	Motor = 51380224,
	AdvBallsocket = 51380224,
	Ballsocket = 51380224
}

hook.Add("CanConstrain","anticrash_constrain_distance", function(tData)
	local Type, Ent1, Ent2, LPos1, LPos2 = tData.Type, tData.Ent1, tData.Ent2, tData.LPos1, tData.LPos2
	local iDist = tMaxSize[Type]

	if iDist then --If distance too great, bail
		if LPos1:LengthSqr() >= iDist and not Ent1:IsWorld() then
			return false
		elseif LPos2 and LPos2:LengthSqr() >= iDist and not Ent2:IsWorld() then
			return false
		end
	elseif Type == "Weld" then --Welds don't crash the server based on distance as easily
		if Ent1:DistToSqr(Ent2) >= 268435456 and not Ent1:IsWorld() and not Ent2:IsWorld() then
			return false
		end
	elseif Type == "Rope" then --Ropes tend to be unstable when their length is 0
		if Ent1:LocalToWorld(LPos1) == Ent2:LocalToWorld(LPos2) and not Ent1:IsWorld() and not Ent2:IsWorld() then
			return false
		end
	end
end)



