# Neovim Configuration AI Context

## Overview

This is a Neovim v0.13+ configuration using native APIs (no lspconfig, no nvim-cmp). Uses `vim.pack` for plugin management.

**Philosophy:** Native-first, zero bloat, fast startup, clean aesthetics.
**Languages:** TypeScript/JS, Go, Rust, C/C++, Lua, Bash

---

## Quick Reference

| Command | Description |
|---------|-------------|
| `nvim` | Open nvim |
| `vim.pack.update()` | Install/update plugins |
| `:LspInfo` | Check LSP status |
| `:TSInstall <lang>` | Install treesitter parser |
| `:checkhealth` | Run health checks |

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                      # Entry: require('core')
├── lua/
│   ├── core/
│   │   ├── init.lua              # Loads: options → autocmds → keymaps → pack
│   │   ├── options.lua           # vim.opt settings
│   │   ├── keymaps.lua           # Global keymaps (no plugin deps)
│   │   ├── autocmds.lua           # Autocommands
│   │   └── pack.lua              # Plugin specs (vim.pack.add)
│   ├── plugins/
│   │   ├── lsp.lua               # Native LSP (vim.lsp.config)
│   │   ├── treesitter.lua        # nvim-treesitter setup
│   │   ├── ui.lua                # tokyonight + statusline
│   │   ├── fuzzy.lua             # fzf-lua
│   │   ├── git.lua               # gitsigns
│   │   ├── editing.lua           # surround, autopairs, mini
│   │   ├── explorer.lua          # neo-tree.nvim
│   │   ├── formatting.lua       # conform.nvim
│   │   ├── linting.lua           # nvim-lint
│   │   └── lang/
│   │       ├── go.lua            # go.nvim
│   │       ├── rust.lua          # crates.nvim
│   │       └── ts.lua            # TS-specific
│   └── util/
│       └── statusline.lua        # Custom statusline renderer
└── guide.md                      # Full documentation
```

---

## Keymaps (Complete)

### General
- `j/k` - Smart movement (respects wrapped lines)
- `n/N` - Search navigation (centered)
- `<C-d>/<C-u>` - Page scroll (centered)
- `<Esc>` - Clear search
- `<C-s>` - Save file
- `<leader>T` - Switch theme (tokyonight ↔ kanagawa)

### Window
- `<C-h/j/k/l>` - Navigate windows
- `<C-Up/Down/Left/Right>` - Resize splits

### Buffer
- `<S-h>/<S-l>` - Prev/next buffer
- `<leader>bd` - Delete buffer
- `<leader>bo` - Close other buffers
- `<leader>bb` - Pick buffer (fzf)
- `<leader>q` - Quickfix

### Terminal
- `<leader>tt` - Open terminal
- `<leader>th` - Horizontal split terminal
- `<leader>tv` - Vertical split terminal
- `<Esc><Esc>` - Exit terminal mode
- `<C-h/j/k/l>` (in terminal) - Navigate windows

### Git
- `]h` / `[h` - Next/prev hunk
- `<leader>gh` - Stage hunk
- `<leader>gr` - Reset hunk
- `<leader>gS` - Stage buffer
- `<leader>gR` - Reset buffer
- `<leader>gp` - Preview hunk
- `<leader>gd` - Diff this
- `<leader>gb` - Blame line

---

## Plugins List

### Core
- `nvim-treesitter/nvim-treesitter` - Parser management
- `nvim-treesitter/nvim-treesitter-textobjects` - Syntax motions
- `ibhagwan/fzf-lua` - Fuzzy finder

### UI
- `folke/tokyonight.nvim` - Colorscheme
- `rebelot/kanagawa.nvim` - Colorscheme (dragon)
- `j-hui/fidget.nvim` - LSP progress
- `lukas-reineke/indent-blankline.nvim` - Indent guides

### Editing
- `kylechui/nvim-surround` - Surround motions
- `windwp/nvim-autopairs` - Auto pairs
- `echasnovski/mini.nvim` - Comment, ai, move

### File/Git
- `nvim-neo-tree/neo-tree.nvim` - Tree file explorer
- `lewis6991/gitsigns.nvim` - Git signs
- `tpope/vim-fugitive` - Git commands

### Format/Lint
- `stevearc/conform.nvim` - Formatting
- `mfussenegger/nvim-lint` - Linting

### Language
- `ray-x/go.nvim` - Go tooling
- `saecki/crates.nvim` - Rust deps
- `b0o/schemastore.nvim` - JSON/YAML schemas

### Optional
- `mfussenegger/nvim-dap` - Debugging
- `rcarriga/nvim-dap-ui` - DAP UI
- `folke/todo-comments.nvim` - TODO highlights

---

## LSP Servers (Configured)

| Server | Language |
|--------|-----------|
| `lua_ls` | Lua |
| `gopls` | Go |
| `rust_analyzer` | Rust |
| `ts_ls` | TypeScript/JS |
| `cssls` | CSS |
| `html` | HTML |
| `jsonls` | JSON |
| `yamlls` | YAML |
| `dockerls` | Docker |
| `bashls` | Bash |
| `clangd` | C/C++ |

---

## Important Patterns

### Adding a new plugin:
Edit `lua/core/pack.lua`:
```lua
vim.pack.add({
  src = 'https://github.com/author/plugin',
  event = 'BufReadPost',  -- or ft = {'go'}, cmd = 'Command'
  config = function() require('plugins.pluginname').setup({}) end,
})
```

### Adding LSP server:
Edit `lua/plugins/lsp.lua`:
```lua
vim.lsp.config('server_name', { settings = {...} })
vim.lsp.enable({ 'server_name' })
```

### Adding keymaps:
Edit `lua/core/keymaps.lua` for global, or use LspAttach autocmd for buffer-local.

### Format on save:
Configured in `lua/plugins/formatting.lua` via conform.nvim.

---

## Dependencies to Install

```bash
# LSP servers
go install golang.org/x/tools/gopls@latest
rustup component add rust-analyzer
npm install -g typescript typescript-language-server @fsouza/prettierd

# Tools
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
# (ripgrep usually pre-installed)
```

---

## Common Tasks

| Task | Command |
|------|---------|
| Install plugins | `nvim --headless +'lua vim.pack.update()' +qa` |
| Install parser | `:TSInstall lua` |
| Restart LSP | `:LspRestart` |
| Format file | `<leader>cf` |
| Open file tree | `-` |
| Toggle comment | `<leader>/` |

---

## Files Reference

- **Core config:** `lua/core/` (options, keymaps, autocmds, pack)
- **Plugin configs:** `lua/plugins/` (lsp, treesitter, ui, fuzzy, git, etc.)
- **Utilities:** `lua/util/statusline.lua`
- **Lang configs:** `lua/plugins/lang/` (go, rust, ts)
- **Full docs:** `guide.md`

---

*For detailed documentation, see `guide.md`*