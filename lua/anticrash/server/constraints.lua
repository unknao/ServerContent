ac_detours.motor = ac_detours.motor or constraint.Motor
ac_detours.axis = ac_detours.axis or constraint.Axis
ac_detours.ballsocket = ac_detours.ballsocket or constraint.Ballsocket
ac_detours.advballsocket = ac_detours.advballsocket or constraint.AdvBallsocket
ac_detours.weld = ac_detours.weld or constraint.Weld

-- if distance too great, bail
local Too_Big = 7168 ^ 2
local Too_Big_Weld = 16384 ^ 2

function constraint.Motor(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
	if Ent1:IsWorld() or Ent2:IsWorld() then return ac_detours.motor(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...) end
	if LPos1:LengthSqr() > Too_Big or LPos2:LengthSqr() > Too_Big then return false end

	return ac_detours.motor(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
end

function constraint.Axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
	if Ent1:IsWorld() or Ent2:IsWorld() then return ac_detours.axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...) end
	if LPos1:LengthSqr() > Too_Big or LPos2:LengthSqr() > Too_Big then return false end

	return ac_detours.axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
end

function constraint.AdvBallsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
	if Ent1:IsWorld() or Ent2:IsWorld() then return ac_detours.advballsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...) end
	if LPos1:LengthSqr() > Too_Big or LPos2:LengthSqr() > Too_Big then return false end

	return ac_detours.advballsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, ...)
end

function constraint.Ballsocket(Ent1, Ent2, Bone1, Bone2, LocalPos, ...)
	if Ent1:IsWorld() or Ent2:IsWorld() then return ac_detours.ballsocket(Ent1, Ent2, Bone1, Bone2, LocalPos, ...) end
	if LocalPos:LengthSqr() > Too_Big then return false end

	return ac_detours.ballsocket(Ent1, Ent2, Bone1, Bone2, LocalPos, ...)
end

function constraint.Weld(Ent1, Ent2, ...)
	local pos1, pos2 = Ent1:GetPos(), Ent2:GetPos()
	--apparently a lot more resilient than the others
	if Ent1:IsWorld() or Ent2:IsWorld() then return ac_detours.weld(Ent1, Ent2, ...) end
	if pos1:DistToSqr(pos2) >= Too_Big_Weld then return false end

	return ac_detours.weld(Ent1, Ent2, ...)
end
