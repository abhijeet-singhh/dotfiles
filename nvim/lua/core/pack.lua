local function setup()
	vim.env.GIT_TERMINAL_PROMPT = "0"

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
		{ src = "https://github.com/hrsh7th/nvim-cmp", name = "nvim-cmp" },
		{ src = "https://github.com/hrsh7th/cmp-nvim-lsp", name = "cmp-nvim-lsp" },
		{ src = "https://github.com/hrsh7th/cmp-buffer", name = "cmp-buffer" },
		{ src = "https://github.com/hrsh7th/cmp-path", name = "cmp-path" },
		{ src = "https://github.com/hrsh7th/cmp-cmdline", name = "cmp-cmdline" },
		{ src = "https://github.com/L3MON4D3/LuaSnip", name = "LuaSnip" },
		{ src = "https://github.com/saadparwaiz1/cmp_luasnip", name = "cmp_luasnip" },
		{ src = "https://github.com/onsails/lspkind.nvim", name = "lspkind" },
	}

	vim.pack.add(specs)

	vim.defer_fn(function()
		local function safe_require(name)
			local ok, mod = pcall(require, name)
			if not ok then vim.notify("Failed to load: " .. name, vim.log.levels.ERROR) end
			return ok and mod
		end
		safe_require("plugins.lsp")
		safe_require("plugins.treesitter")
		safe_require("plugins.fuzzy")
		safe_require("plugins.ui")
		safe_require("plugins.cmp")
		safe_require("fidget").setup({
			notification = { window = { winblend = 0, border = "none", align = "bottom" } },
			progress = { display = { render_limit = 4, done_ttl = 2 } },
		})
		safe_require("plugins.git")
		safe_require("plugins.editing")
		local npairs = safe_require("nvim-autopairs")
		if npairs then npairs.setup({ check_ts = true, ts_config = {} }) end
		safe_require("mini.comment").setup({ options = { ignore_comment_line = true } })
		safe_require("mini.ai").setup({ n_lines = 500 })
		safe_require("mini.move").setup({})
		safe_require("plugins.explorer")
		safe_require("plugins.statusline")
		safe_require("plugins.formatting")
		safe_require("plugins.linting")
		safe_require("plugins.lang.go")
		safe_require("plugins.lang.rust")
		safe_require("plugins.lang.ts")
		local ibl = safe_require("ibl")
		if ibl then
			ibl.setup({
				indent = { char = "│", highlight = "WinSeparator" },
				exclude = { filetypes = { "help", "dashboard" } },
				scope = { enabled = true, show_start = false },
			})
		end
		safe_require("todo-comments")
		safe_require("bufferline").setup({})
	end, 0)
end

return { setup = setup }