local tag = "MassUndo"
local bUndoHeld
local iUndoKey = input.GetKeyCode(input.LookupBinding("undo"))

hook.Add("PlayerBindPress", tag, function(_, sBind)
	if not sBind:find("undo") then return end

	timer.Create(tag, 0.5, 1, function()
		--"Pressed" argument of this hook always returns true, so the workaround is necessary.
		bUndoHeld = input.IsButtonDown(iUndoKey)
		if not bUndoHeld then return end

		hook.Add("Tick", tag, function()
			bUndoHeld = input.IsButtonDown(iUndoKey)
			if not bUndoHeld then
				hook.Remove("Tick", tag)
				return
			end

			for _ = 1, 100 do RunConsoleCommand("undo") end
		end)
	end)
end)