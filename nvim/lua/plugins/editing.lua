require("nvim-surround").setup()

local npairs = require("nvim-autopairs")
npairs.setup({ check_ts = true, ts_config = {} })

require("mini.comment").setup({
	options = { ignore_comment_line = true },
})

require("mini.ai").setup({
	n_lines = 500,
	custom_textobjects = {
		g = function()
			local from = vim.fn.getpos("'<")
			local to = vim.fn.getpos("'>")
			return { from = { line = from[2], col = from[3] }, to = { line = to[2], col = to[3] } }
		end,
	},
})

require("mini.move").setup({
	mappings = {
		left = "<A-left>",
		right = "<A-right>",
		down = "<A-down>",
		up = "<A-up>",
		line_down = "<A-j>",
		line_up = "<A-k>",
	},
})

vim.keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment" })
vim.keymap.set("x", "<leader>/", "gc", { desc = "Toggle comment" })
vim.keymap.set("n", "gc", "gcc", { desc = "Toggle comment" })

