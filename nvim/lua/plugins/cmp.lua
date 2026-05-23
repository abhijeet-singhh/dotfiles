-- ══════════════════════════════════════════════════════════════
--  cmp.lua  ·  complete autocomplete setup
--  Sources: LSP · signature · luasnip · buffer · path · cmdline
-- ══════════════════════════════════════════════════════════════

-- ── LuaSnip ──────────────────────────────────────────────────
local luasnip = require("luasnip")

luasnip.setup({
	history = true,
	update_events = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged,InsertLeave",
	region_check_events = "CursorMoved",
})

require("luasnip.loaders.from_vscode").lazy_load()
-- Optional: load your own Lua snippets
-- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

-- ── LSP capabilities ─────────────────────────────────────────
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

-- ── Helpers ───────────────────────────────────────────────────
local function has_words_before()
	if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
		return false
	end
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]:sub(col, col):match("%s") == nil
end

-- ── nvim-autopairs hook (safe — no-ops if not installed) ─────
local ok_ap, cmp_ap = pcall(require, "nvim-autopairs.completion.cmp")

-- ── cmp ───────────────────────────────────────────────────────
local cmp = require("cmp")
local lspkind = require("lspkind")

-- Shared insert-mode source list
local SOURCES = {
	{ name = "nvim_lsp", priority = 1000, keyword_length = 1, max_item_count = 80 },
	{ name = "nvim_lsp_signature_help", priority = 950, keyword_length = 1 },
	{ name = "luasnip", priority = 900, keyword_length = 2, max_item_count = 20 },
	-- ── AI completions: uncomment whichever you have ──────────
	-- { name = "copilot",   priority = 850 },
	-- { name = "codeium",   priority = 850 },
	-- { name = "supermaven",priority = 850 },
	{
		name = "buffer",
		priority = 700,
		keyword_length = 3,
		max_item_count = 15,
		option = {
			get_bufnrs = function()
				-- only loaded buffers under 1 MB (keeps cmp fast)
				return vim.tbl_filter(function(b)
					return vim.api.nvim_buf_is_loaded(b)
						and vim.api.nvim_buf_get_offset(b, vim.api.nvim_buf_line_count(b)) < 1024 * 1024
				end, vim.api.nvim_list_bufs())
			end,
		},
	},
	{
		name = "path",
		priority = 500,
		keyword_length = 2,
		option = { trailing_slash = true, label_trailing_slash = true },
	},
	-- { name = "calc", priority = 300 },  -- hrsh7th/cmp-calc
}

cmp.setup({
	-- ── Behaviour ────────────────────────────────────────────
	completion = {
		autocomplete = { cmp.TriggerEvent.TextChanged },
		completeopt = "menu,menuone,noinsert",
	},
	preselect = cmp.PreselectMode.None, -- never auto-select; confirm is deliberate

	experimental = {
		ghost_text = { hl_group = "CmpGhostText" },
	},

	-- ── Snippet engine ───────────────────────────────────────
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	-- ── Mappings ─────────────────────────────────────────────
	mapping = cmp.mapping.preset.insert({

		-- Navigate list
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

		-- Scroll documentation
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),

		-- Manually open completion menu
		["<C-Space>"] = cmp.mapping.complete(),

		-- Abort / close
		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.config.disable, -- disable vim's default confirm

		-- Confirm (replace word)
		["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
		-- Confirm (insert, keeps rest of word)
		["<S-CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),

		-- Tab: cmp select → snippet jump → trigger complete → indent
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	-- ── Formatting / UI ──────────────────────────────────────
	formatting = {
		fields = { "kind", "abbr", "menu" },
		expandable_indicator = true,
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "…",
			show_labelDetails = true, -- show return type / detail from LSP
			before = function(entry, item)
				local labels = {
					nvim_lsp = "lsp",
					nvim_lsp_signature_help = "sig",
					luasnip = "snip",
					buffer = "buf",
					path = "path",
					copilot = "ai",
					codeium = "ai",
					supermaven = "ai",
					calc = "calc",
					cmdline = "cmd",
					nvim_lua = "lua",
				}
				item.menu = ("  [%s]"):format(labels[entry.source.name] or entry.source.name)
				return item
			end,
		}),
	},

	-- ── Sources ──────────────────────────────────────────────
	sources = cmp.config.sources(SOURCES),

	-- ── Window ───────────────────────────────────────────────
	window = {
		completion = cmp.config.window.bordered({
			winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
			col_offset = -3,
			side_padding = 0,
			scrollbar = false,
		}),
		documentation = cmp.config.window.bordered({
			winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder,CursorLine:CmpDocSel,Search:None",
			max_width = 80,
			max_height = 20,
		}),
	},

	-- ── Sorting ──────────────────────────────────────────────
	sorting = {
		priority_weight = 2,
		comparators = {
			-- Sink deprecated LSP items to the bottom
			function(a, b)
				local DEPRECATED = 1
				local ad = a.completion_item.deprecated
					or (a.completion_item.tags and vim.tbl_contains(a.completion_item.tags, DEPRECATED))
				local bd = b.completion_item.deprecated
					or (b.completion_item.tags and vim.tbl_contains(b.completion_item.tags, DEPRECATED))
				if ad ~= bd then
					return not ad
				end
			end,
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})

-- ── Cmdline: /  and  ? (search) ──────────────────────────────
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = { { name = "buffer", keyword_length = 2 } },
})

-- ── Cmdline: : (ex commands + path) ──────────────────────────
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	completion = { autocomplete = { cmp.TriggerEvent.TextChanged } },
	sources = cmp.config.sources(
		{ { name = "path" } },
		{ { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
	),
})

-- ── Filetype: Lua (vim API completions) ───────────────────────
-- Requires hrsh7th/cmp-nvim-lua
cmp.setup.filetype("lua", {
	sources = cmp.config.sources({ { name = "nvim_lua", priority = 1100 } }, SOURCES),
})

-- ── Filetype: gitcommit ───────────────────────────────────────
-- Requires petertriho/cmp-git (optional)
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({ { name = "git" } }, { { name = "buffer", keyword_length = 3 } }),
})

-- ── Autopairs confirm hook ────────────────────────────────────
if ok_ap then
	cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
end

-- ── Highlights (theme-safe links) ────────────────────────────
local hl = vim.api.nvim_set_hl
hl(0, "CmpNormal", { link = "NormalFloat" })
hl(0, "CmpBorder", { link = "FloatBorder" })
hl(0, "CmpSel", { link = "PmenuSel" })
hl(0, "CmpDocNormal", { link = "NormalFloat" })
hl(0, "CmpDocBorder", { link = "FloatBorder" })
hl(0, "CmpDocSel", { link = "PmenuSel" })
hl(0, "CmpGhostText", { link = "Comment", italic = true })

-- ── Auto-close when exiting snippet session ───────────────────
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "[s]:*",
	callback = function()
		if cmp.visible() and not luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
			cmp.close()
		end
	end,
})

-- ── Expose capabilities for lspconfig ────────────────────────
return { capabilities = capabilities }
