ac_detours.rope = ac_detours.rope or constraint.Rope

constraint.Rope=function(ent1, ent2, ...)
	if ent1 == ent2 and ent1 == game.GetWorld() then return false end
	return ac_detours.rope(ent1,ent2,...)
end
