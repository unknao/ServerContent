a7702_errors = a7702_errors or {}

function GetGlobalErrorTable()
	return a7702_errors
end

function ClearErrorTable()
	table.Empty(a7702_errors)
end
