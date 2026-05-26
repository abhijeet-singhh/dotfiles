local M = {}
local available = {}
local current_theme = nil

function M.register(name, mod)
	available[name] = mod
end

function M.list()
	return vim.tbl_keys(available)
end

function M.apply(name)
	if available[name] then
		available[name].setup()
		current_theme = name
		return true
	end
	return false
end

function M.current()
	return current_theme
end

return M
