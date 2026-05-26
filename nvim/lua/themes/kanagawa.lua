local M = {}

function M.setup()
	require("kanagawa").setup({
		style = "dragon",
		transparent = false,
		overrides = function(colors)
			return {
				CursorLineNr = { fg = colors.palette.waveOrange, bold = true },
				LineNr = { fg = colors.palette.fujiGray },
				WinSeparator = { fg = colors.palette.sumiInk2 },
			}
		end,
	})
	vim.cmd.colorscheme("kanagawa-dragon")
end

return M
