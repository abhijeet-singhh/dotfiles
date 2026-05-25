local themes = {
	kanagawa = {
		setup = function()
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
		end,
	},
	pywal = {
		setup = function()
			pcall(function()
				require("pywal16").setup()
			end)
		end,
	},
}

local current_theme = "kanagawa"
themes[current_theme].setup()

vim.keymap.set("n", "<leader>T", function()
	local keys = vim.tbl_keys(themes)
	local idx = 0
	for i, k in ipairs(keys) do
		if k == current_theme then
			idx = i
			break
		end
	end
	local next_idx = (idx % #keys) + 1
	current_theme = keys[next_idx]
	themes[current_theme].setup()
	vim.notify("Theme: " .. current_theme, vim.log.levels.INFO, { title = "Theme Switcher" })
end, { desc = "Switch colorscheme" })
