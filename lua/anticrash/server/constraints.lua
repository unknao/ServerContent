ac_detours.motor = ac_detours.motor or constraint.Motor
ac_detours.axis = ac_detours.axis or constraint.Axis
ac_detours.ballsocket = ac_detours.ballsocket or constraint.Ballsocket
ac_detours.advballsocket = ac_detours.advballsocket or constraint.AdvBallsocket
ac_detours.weld = ac_detours.weld or constraint.Weld

-- if distance too great, bail
local Too_Big = 7168

function constraint.Motor(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
	if LPos1:Distance(LPos2) >= Too_Big then return false end
	return ac_detours.motor(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
end

function constraint.Axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
	if LPos1:Distance(LPos2) >= Too_Big then return false end
	return ac_detours.axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
end

function constraint.Ballsocket(Ent1, Ent2, Bone1, Bone2, LocalPos, ...)
	if LocalPos:Length() >= Too_Big then return false end
	return ac_detours.ballsocket(Ent1, Ent2, Bone1, Bone2, LocalPos, ...)
end
	
function constraint.AdvBallsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
	if LPos1:Distance(LPos2) >= Too_Big then return false end
	return ac_detours.advballsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
end
	
function constraint.Weld(ent1, ent2, ...)
	local pos1, pos2 = ent1:GetPos(), ent2:GetPos()
	--apparently a lot more resilient than the others
	if pos1:Distance(pos2) >= 16384 then return false end
	return ac_detours.weld(ent1, ent2, ...)
end
	