local function setup()
	local specs = {
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
			name = "nvim-treesitter-textobjects",
		},
		{ src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
		{ src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight" },
		{ src = "https://github.com/rebelot/kanagawa.nvim", name = "kanagawa" },
		{ src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine" },
		{ src = "https://github.com/j-hui/fidget.nvim", name = "fidget" },
		{ src = "https://github.com/lewis6991/gitsigns.nvim", name = "gitsigns" },
		{ src = "https://github.com/kylechui/nvim-surround", name = "nvim-surround" },
		{ src = "https://github.com/windwp/nvim-autopairs", name = "nvim-autopairs" },
		{ src = "https://github.com/echasnovski/mini.nvim", name = "mini" },
		{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", name = "neo-tree", version = "v3.x" },
		{ src = "https://github.com/nvim-lua/plenary.nvim", name = "plenary" },
		{ src = "https://github.com/MunifTanjim/nui.nvim", name = "nui" },
		{ src = "https://github.com/akinsho/bufferline.nvim", name = "bufferline" },
		{ src = "https://github.com/tpope/vim-fugitive", name = "vim-fugitive" },
		{ src = "https://github.com/stevearc/conform.nvim", name = "conform" },
		{ src = "https://github.com/mfussenegger/nvim-lint", name = "nvim-lint" },
		{ src = "https://github.com/ray-x/go.nvim", name = "go" },
		{ src = "https://github.com/ray-x/guihua.lua", name = "guihua" },
		{ src = "https://github.com/saecki/crates.nvim", name = "crates" },
		{ src = "https://github.com/b0o/schemastore.nvim", name = "schemastore" },
		{ src = "https://github.com/lukas-reineke/indent-blankline.nvim", name = "indent-blankline" },
		{ src = "https://github.com/mfussenegger/nvim-dap", name = "nvim-dap" },
		{ src = "https://github.com/rcarriga/nvim-dap-ui", name = "nvim-dap-ui" },
		{ src = "https://github.com/leoluz/nvim-dap-go", name = "nvim-dap-go" },
		{ src = "https://github.com/folke/todo-comments.nvim", name = "todo-comments" },
		{ src = "https://github.com/dstein64/vim-startuptime", name = "vim-startuptime" },
		{ src = "https://github.com/tpope/vim-sleuth", name = "vim-sleuth" },
		{ src = "https://github.com/wakatime/vim-wakatime", name = "vim-wakatime" },
	}

	vim.pack.add(specs, { load = true })

	vim.defer_fn(function()
		require("plugins.treesitter")
		require("plugins.fuzzy")
		require("plugins.ui")
		require("fidget").setup({
			notification = { window = { winblend = 0, border = "none", align = "bottom" } },
			progress = { display = { render_limit = 4, done_ttl = 2 } },
		})
		require("plugins.git")
		require("plugins.editing")
		local npairs = require("nvim-autopairs")
		npairs.setup({ check_ts = true, ts_config = {} })
		require("mini.comment").setup()
		require("mini.ai").setup()
		require("mini.move").setup()
		require("plugins.explorer")
		require("plugins.statusline")
		require("plugins.formatting")
		require("plugins.linting")
		require("plugins.lang.go")
		require("plugins.lang.rust")
		require("plugins.lang.ts")
		require("ibl").setup({
			indent = { char = "│", highlight = "WinSeparator" },
			exclude = { filetypes = { "help", "dashboard" } },
			scope = { enabled = true, show_start = false },
		})
		require("todo-comments").setup()

		require("bufferline").setup({})
	end, 0)
end

return { setup = setup }
