local tag = "MassUndo"
local iUndoKey = input.GetKeyCode(input.LookupBinding("undo"))

hook.Add("PlayerButtonDown", tag, function(_, iButton)
	if iButton ~= iUndoKey then return end

	timer.Create(tag, 0.5, 1, function()
		hook.Add("Tick", tag, function()
			for _ = 1, 100 do RunConsoleCommand("undo") end
		end)
	end)
end)
hook.Add("PlayerButtonUp", tag, function(_, iButton)
	if iButton ~= iUndoKey then return end

	timer.Remove(tag)
	hook.Remove("Tick", tag)
end)