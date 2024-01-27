local tag = "MassUndo"
local undo_held

hook.Add("PlayerBindPress", tag, function(_, bind, pressed)
	local is_undo = string.find(bind, "undo")
	if not is_undo then return end

	undo_held = pressed
	if undo_held then
		timer.Simple(0.5, function()
			if not undo_held then return end

			hook.Add("Tick", tag, function()
				for _ = 1, 100 do RunConsoleCommand("undo") end
			end)
		end)
	else
		hook.Remove("Tick", tag)
	end
end)