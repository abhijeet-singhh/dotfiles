local function mode()
	local m = vim.api.nvim_get_mode().mode
	local mode_map = {
		["n"] = "N",
		["i"] = "I",
		["v"] = "V",
		["V"] = "VL",
		["\22"] = "VB",
		["c"] = "C",
		["r"] = "P",
		["t"] = "T",
	}
	return (mode_map[m] or m)
end

local function git()
	local ok, gs = pcall(require, "gitsigns")
	if not ok then
		return ""
	end

	local head = gs.head
	if not head or head == "" then
		return ""
	end

	local added = 0
	local changed = 0
	local removed = 0

	local status = gs.get_status()
	if status then
		added = status.added or 0
		changed = status.changed or 0
		removed = status.removed or 0
	end

	if added > 0 or changed > 0 or removed > 0 then
		return head .. " +" .. added .. " ~" .. changed .. " -" .. removed
	end
	return head
end

local render = function()
	local left = mode() .. " " .. git()
	local right = "%y"
	return left .. "%=" .. right
end

return { render = render }
