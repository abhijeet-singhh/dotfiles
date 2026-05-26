local M = {}

function M.setup()
	pcall(function()
		require("pywal16").setup()
	end)
end

return M
