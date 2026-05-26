# Neovim Configuration Guide

## For NVIM v0.13.0-dev (Nightly) | Lua-based | Performance-first

> **Target:** Advanced frontend → full-stack/systems engineer
> **Languages:** TypeScript/JS, Go, Rust, C/C++, Lua, Bash
> **Philosophy:** Native-first, zero bloat, fast startup, clean aesthetics

---

## Table of Contents

1. [Quick Start](#1-quick-start)
2. [Directory Structure](#2-directory-structure)
3. [Prerequisites - What to Install](#3-prerequisites---what-to-install)
4. [Plugin Overview](#4-plugin-overview)
5. [Keymaps Reference](#5-keymaps-reference)
6. [Features & Configuration Details](#6-features--configuration-details)
7. [Language-Specific Setup](#7-language-specific-setup)
8. [Performance](#8-performance)
9. [Troubleshooting](#9-troubleshooting)

---

## 1. Quick Start

### First Time Setup

```bash
# 1. Verify Neovim version (must be v0.13+)
nvim --version

# 2. Install all plugins
GIT_TERMINAL_PROMPT=0 nvim --headless "+lua vim.pack.update()" +qa

# 3. Install LSP servers (see Section 3)

# 4. Install Treesitter parsers (inside nvim)
:TSInstall lua vim go rust typescript javascript

# 5. Test the config
nvim
```

### Daily Usage

```bash
nvim filename.lua    # Open a file
```

---

## 2. Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - only requires 'core'
└── lua/
    ├── core/
    │   ├── init.lua            # Orchestrates load order
    │   ├── options.lua         # All vim.opt settings (performance + UI)
    │   ├── keymaps.lua         # Global keymaps (no plugin deps)
    │   ├── autocmds.lua        # Global autocommands
    │   └── pack.lua            # vim.pack plugin registration
    ├── plugins/
    │   ├── lsp.lua             # Native LSP config (v0.13+)
    │   ├── treesitter.lua      # Parser management
    │   ├── ui.lua              # Colorscheme setup + theme switcher
    │   ├── fuzzy.lua           # fzf-lua configuration
    │   ├── git.lua             # gitsigns configuration
    │   ├── editing.lua         # surround, autopairs, mini modules
    │   ├── explorer.lua        # neo-tree.nvim file explorer
    │   ├── formatting.lua      # conform.nvim formatter
    │   ├── linting.lua         # nvim-lint linter
    │   ├── cmp.lua             # nvim-cmp autocompletion setup
    │   └── lang/
    │       ├── go.lua          # Go-specific setup (go.nvim)
    │       ├── rust.lua        # Rust-specific setup (crates.nvim)
    │       └── ts.lua          # TypeScript-specific setup
    ├── themes/
    │   ├── init.lua            # Theme module: register, list, apply
    │   ├── kanagawa.lua        # Kanagawa dragon config
    │   └── pywal.lua           # Pywal16 config (wallpaper-based)
    └── util/
        └── statusline.lua      # Custom statusline renderer
```

---

## 3. Prerequisites - What to Install

### LSP Servers (Language Servers)

Install these via your system package manager or direct binary installation:

```bash
# === Go ===
go install golang.org/x/tools/gopls@latest
go install github.com/rust-analyzer/rust-analyzer@latest  # optional, rustup also works

# === Rust ===
rustup component add rust-analyzer

# === TypeScript/JavaScript ===
npm install -g typescript typescript-language-server
npm install -g @fsouza/prettierd  # fast prettier daemon

# === Lua ===
# Download lua-language-server from GitHub releases
# https://github.com/LuaLS/lua-language-server/releases

# === CSS/HTML/JSON ===
npm install -g vscode-langservers-extracted

# === YAML ===
npm install -g yaml-language-server

# === Docker ===
npm install -g dockerfile-language-server-nodejs

# === Bash ===
npm install -g bash-language-server

# === C/C++ (install via system) ===
# Ubuntu: apt install clangd
# macOS: brew install clangd
# Arch: pacman -S clang
```

### Required Tools

```bash
# Fuzzy finder backend (required for fzf-lua)
# Install fzf binary - https://github.com/junegunn/fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Ripgrep (required for grep functionality)
# Most systems have this installed, verify with: which rg

# Git (obviously needed)
# Verify: which git
```

### Verify Installations

```bash
# Check all required binaries
which rg fzf gopls rust-analyzer ts_ls clangd lua-language-server
```

---

## 4. Plugin Overview

### Core Plugins

| Plugin | Purpose | Lazy Loading |
|--------|---------|--------------|
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting, parsing | `BufReadPost` |
| `nvim-treesitter/nvim-treesitter-textobjects` | Syntax-aware motions (`af`, `if`, etc.) | `BufReadPost` |
| `ibhagwan/fzf-lua` | Fast fuzzy finder (uses fzf binary) | `cmd: FzfLua` |

### Autocompletion (nvim-cmp)

| Plugin | Purpose |
|-------|---------|
| `hrsh7th/nvim-cmp` | Main completion engine |
| `hrsh7th/cmp-nvim-lsp` | LSP completion source |
| `hrsh7th/cmp-buffer` | Buffer words completion |
| `hrsh7th/cmp-path` | Path completion |
| `hrsh7th/cmp-cmdline` | Command line completion |
| `L3MON4D3/LuaSnip` | Snippet engine |
| `saadparwaiz1/cmp_luasnip` | Snippet completion source |
| `onsails/lspkind.nvim` | Kind icons for completion menu |

### UI Plugins

| Plugin | Purpose | Lazy Loading |
|--------|---------|--------------|
| `uZer/pywal16.nvim` | Wallpaper-based colorscheme | `VimEnter` |
| `rebelot/kanagawa.nvim` | Dark colorscheme (dragon style) | `VimEnter` |
| `j-hui/fidget.nvim` | LSP progress indicator | `LspAttach` |
| `lukas-reineke/indent-blankline.nvim` | Indent guides | `BufReadPost` |

### Editing Plugins

| Plugin | Purpose | Keymaps |
|--------|---------|---------|
| `kylechui/nvim-surround` | Surround text objects | `cs"`, `ds"`, `ysiw"` |
| `windwp/nvim-autopairs` | Auto-close brackets/quotes | Automatic |
| `echasnovski/mini.nvim` | Comment, better textobjects, move | `<leader>/`, `gc` |

### File Management

| Plugin | Purpose | Keymaps |
|--------|---------|---------|
| `nvim-neo-tree/neo-tree.nvim` | Tree file explorer | `-`, `<leader>e` |

### Git Plugins

| Plugin | Purpose | Keymaps |
|--------|---------|---------|
| `lewis6991/gitsigns.nvim` | Git hunk signs + actions | `]h`, `[h`, `<leader>gs` |
| `tpope/vim-fugitive` | Git commands (`:G`, etc.) | `:G` command |

### Formatting & Linting

| Plugin | Purpose | Trigger |
|--------|---------|---------|
| `stevearc/conform.nvim` | Async formatting | `BufWritePost` |
| `mfussenegger/nvim-lint` | Async linting | `BufWritePost`, `InsertLeave` |

### Language-Specific

| Plugin | Purpose | Languages |
|--------|---------|-----------|
| `ray-x/go.nvim` | Go tooling (run, test, coverage) | Go |
| `saecki/crates.nvim` | Cargo.toml dependency management | Rust |
| `b0o/schemastore.nvim` | JSON/YAML schema validation | JSON, YAML |

### Debugging (optional)

| Plugin | Purpose |
|--------|---------|
| `mfussenegger/nvim-dap` | Debug Adapter Protocol |
| `rcarriga/nvim-dap-ui` | DAP UI |
| `leoluz/nvim-dap-go` | Go debugger |

---

## 5. Keymaps Reference

### Leader Key

```
<leader> = Space
<localleader> = \
```

### General Navigation

| Keymap | Action |
|--------|--------|
| `j` | Move down (smart - respects wrapped lines) |
| `k` | Move up (smart - respects wrapped lines) |
| `n` | Next search result (centered) |
| `N` | Previous search result (centered) |
| `<C-d>` | Page down (centered) |
| `<C-u>` | Page up (centered) |
| `<Esc>` | Clear search highlight |

### Window Navigation

| Keymap | Action |
|--------|--------|
| `<C-h>` | Navigate to window left |
| `<C-j>` | Navigate to window down |
| `<C-k>` | Navigate to window up |
| `<C-l>` | Navigate to window right |
| `<C-Up>` | Resize: increase height |
| `<C-Down>` | Resize: decrease height |
| `<C-Left>` | Resize: decrease width |
| `<C-Right>` | Resize: increase width |

### Buffer Management

| Keymap | Action |
|--------|--------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete current buffer |
| `<leader>bD` | Force delete buffer |
| `<leader>bo` | Close other buffers |
| `<leader>bb` | Pick buffer (fuzzy finder) |
| <code><leader>`</code> | Jump to last buffer |
| `<leader>1-9` | Go to buffer 1-9 (via bufferline) |

Note: Bufferline shows tabs at the top with buffer names and modified indicators.

### Themes

| Keymap | Action |
|--------|--------|
| `<leader>T` | Open fzf theme picker (select from registered themes) |

### Quickfix

| Keymap | Action |
|--------|--------|
| `]q` | Next quickfix item |
| `[q` | Previous quickfix item |
| `<leader>q` | Open quickfix window |

### Terminal

| Keymap | Action |
|--------|--------|
| `<leader>tt` | Open terminal |
| `<leader>th` | Open terminal (horizontal split) |
| `<leader>tv` | Open terminal (vertical split) |
| `<Esc><Esc>` (in terminal) | Exit terminal mode |
| `<C-h/j/k/l>` (in terminal) | Navigate windows |

### File Operations (Fuzzy Finding)

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Find recent files |
| `<leader>fh` | Find help tags |
| `<leader>fs` | Find document symbols |
| `<leader>fS` | Find workspace symbols |
| `<leader>fw` | Find word under cursor |
| `<leader>fW` | Find WORD under cursor |
| `<leader>fc` | Find in current buffer |
| `<leader>fd` | Find diagnostics (document) |
| `<leader>fD` | Find diagnostics (workspace) |
| `<leader>fk` | Find keymaps |
| `<leader>ft` | Find treesitter nodes |

### Git

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Open lazygit (requires lazygit installed) |
| `<leader>gl` | Git commits (fzf-lua) |
| `<leader>gL` | Git commits for buffer (fzf-lua) |
| `<leader>gb` | Git branches |
| `<leader>gs` | Git status |
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `<leader>gh` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage buffer |
| `<leader>gR` | Reset buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gd` | Diff this |
| `<leader>gb` | Blame line |

### LSP (Language Server Protocol)

| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | References |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` | Signature help (normal + insert) |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format document |
| `<leader>ci` | Incoming calls |
| `<leader>co` | Outgoing calls |
| `<leader>cs` | Document symbols |
| `<leader>cS` | Workspace symbols |
| `<leader>ch` | Toggle inlay hints |

### Autocompletion (nvim-cmp)

| Keymap | Action |
|--------|--------|
| `<C-n>` / `<C-p>` | Navigate completion items |
| `<C-d>` / `<C-f>` | Scroll documentation |
| `<Tab>` | Select next / expand snippet |
| `<S-Tab>` | Select previous / jump back |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort completion |
| `Ctrl+Y` | Disable completion |

### Diagnostics

| Keymap | Action |
|--------|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>dd` | Show diagnostic float |
| `<leader>dl` | Diagnostics to loclist |

### File Explorer (neo-tree.nvim)

| Keymap | Action |
|--------|--------|
| `-` | Toggle file explorer |
| `<leader>e` | Open explorer at current file |
| `<leader>o` | Toggle outline (symbols) |
| `<Tab>` | Expand/collapse folder |
| `<S-CR>` | Toggle node (expand/collapse) |
| `h` | Navigate up (parent dir) |
| `l` or `<CR>` | Open file/directory |
| `/` | Fuzzy finder in directory |
| `a` | Add new file/folder |
| `D` | Delete |
| `r` | Rename |
| `m` | Move |
| `c` | Copy |
| `q` | Close explorer |

### Editing

| Keymap | Action |
|--------|--------|
| `cs"` | Change surrounding " to ' |
| `ds"` | Delete surrounding " |
| `ysiw"` | Add " around inner word |
| `<leader>/` | Toggle comment |
| `gc` + motion | Comment operator (visual) |
| `gcc` | Comment current line (normal) |
| `<A-j>` | Move line down (visual) |
| `<A-k>` | Move line up (visual) |
| `<` | Indent (visual, keep selection) |
| `>` | Indent (visual, keep selection) |
| `p` | Paste without overwriting register |

### Formatting

| Keymap | Action |
|--------|--------|
| `<leader>cf` | Format document (conform.nvim) |

---

## 6. Features & Configuration Details

### 6.1 Autocompletion (nvim-cmp)

High-performance completion engine with multiple sources:

**Completion Sources (by priority):**
1. LSP (`nvim_lsp`) - Language server completions (priority 1000)
2. Signature Help - Function signature completions (priority 950)
3. LuaSnip - Snippet expansions (priority 900)
4. Buffer - Words from other buffers (priority 700)
5. Path - File path completions (priority 500)

**Features:**
- Auto-trigger on text change and insert enter
- Ghost text for preview
- Bordered completion and documentation windows
- Snippet expansion with `<Tab>` / `<S-Tab>`
- Fuzzy matching
- Recent usage weighting

**Snippet Support:**
- LuaSnip engine with friendly-snippets
- `<Tab>` to expand snippets
- Jump forward with `<Tab>`, jump back with `<S-Tab>`

### 6.2 Native LSP (v0.13+)

This config uses Neovim's native LSP API (no `lspconfig` plugin needed):

**Configured Servers:**
- `lua_ls` - Lua
- `gopls` - Go
- `rust_analyzer` - Rust
- `ts_ls` - TypeScript/JavaScript
- `cssls` - CSS
- `html` - HTML
- `jsonls` - JSON
- `yamlls` - YAML
- `dockerls` - Docker
- `bashls` - Bash
- `clangd` - C/C++

**Native Completion:**
- Enabled via `cmp-nvim-lsp` integration
- Triggered automatically on typing
- Uses `vim.opt.completeopt` settings

**Inlay Hints:**
- Toggle with `<leader>ch`
- Supported for Rust, TypeScript, Go

### 6.3 Treesitter

**Installed Parsers:**
- Languages: lua, vim, vimdoc, query
- Go: go, gomod, gowork, gosum
- Rust: rust, toml
- Web: typescript, tsx, javascript, html, css, scss
- Config: json, jsonc, yaml, toml
- Shell: bash, fish
- Systems: c, cpp
- Python
- Docs: markdown, markdown_inline
- Infra: dockerfile, terraform, hcl
- Database: sql
- Regex, comment, diff
- Git: git_config, gitignore, gitcommit

**Textobjects:**
- `af` - Around function
- `if` - Inside function
- `ac` - Around class
- `ic` - Inside class
- `aa` - Around parameter
- `ia` - Inside parameter
- `ab` - Around block
- `ib` - Inside block
- `al` - Around loop
- `il` - Inside loop
- `ai` - Around conditional
- `ii` - Inside conditional

**Incremental Selection:**
- `<C-space>` - Start/init selection
- `<C-s>` - Scope selection
- `<bs>` - Decrease selection

### 6.4 Statusline (Custom)

Built from scratch in `lua/util/statusline.lua` - no plugin overhead.

**Left side:**
- Mode (Normal/Insert/Visual/Command/Terminal)
- Git branch (via gitsigns)
- Filename + modified indicator

**Right side:**
- LSP diagnostics (E:count, W:count)
- File type
- Encoding
- Line:Column
- Percentage through file

**Mode Colors:**
- Normal: Blue
- Insert: Green
- Visual: Orange/Purple
- Command: Yellow
- Replace: Red
- Terminal: Cyan

### 6.5 Theme System

Modular theme system in `lua/themes/`. Each theme is a separate file that exports a `setup()` function.

**To add a new theme:**
1. Create `lua/themes/mytheme.lua` returning `{ setup = function() ... end }`
2. Register it in `lua/plugins/ui.lua`:
   ```lua
   themes.register("mytheme", require("themes.mytheme"))
   ```
3. It'll appear in the `<leader>T` fzf picker automatically.

**Default theme** is set via `themes.apply("kanagawa")` in `ui.lua`.

### 6.6 Fuzzy Finder (fzf-lua)

Uses the `fzf` binary for maximum speed. All keymaps use `<leader>f*` prefix.

Features:
- Files, buffers, recent files
- Live grep with preview
- Git commits, branches, status
- LSP symbols
- Diagnostics
- Keymaps
- Treesitter nodes

### 6.7 File Explorer (neo-tree.nvim)

Tree-style file explorer with expand/collapse folders.

Features:
- `-` toggles file explorer
- `<leader>e` opens explorer at current file location
- `<leader>o` toggles outline (document symbols view)
- `<Tab>` or `<S-CR>` expands/collapses folders
- `h` goes to parent directory
- `l` or `<CR>` opens file or directory
- `/` fuzzy finder within directory
- `a` adds new file (append `/` for folder)
- `D` deletes to trash
- `r` renames
- `m` moves
- `c` copies
- Shows git status icons
- Real-time file watching

### 6.8 Formatting (conform.nvim)

Async formatting, runs on save.

Formatters by language:
- Lua: stylua
- Go: goimports, gofmt
- Rust: rustfmt
- TypeScript/JS: prettierd
- JSON/HTML/CSS/YAML: prettierd
- Markdown: prettierd
- Shell: shfmt

### 6.9 Linting (nvim-lint)

Async linting on save and after leaving insert mode.

Linters by language:
- Go: golangcilint
- TypeScript/JS: eslint_d
- Shell: shellcheck
- Docker: hadolint

---

## 7. Language-Specific Setup

### 7.1 Go

**Keymaps:**
| Keymap | Action |
|--------|--------|
| `<leader>lr` | Run current file |
| `<leader>lt` | Run tests |
| `<leader>lT` | Run test file |
| `<leader>lc` | Show coverage |
| `<leader>li` | Add import |
| `<leader>la` | Alternate (test file) |
| `<leader>lf` | Fill struct |
| `<leader>le` | Add if err |
| `<leader>lt` | Add struct tags |

**Requirements:**
- `gopls` LSP server
- `goimports` / `gofmt` (gopls provides both)
- `delve` for debugging

### 7.2 Rust

**Keymaps:**
| Keymap | Action |
|--------|--------|
| `<leader>lr` | Cargo run |
| `<leader>lb` | Cargo build |
| `<leader>lt` | Cargo test |
| `<leader>lc` | Cargo clippy |

**Requirements:**
- `rust-analyzer` LSP server
- `cargo`, `rustfmt`, `clippy` (via rustup)
- `crates.nvim` for Cargo.toml dependency management

### 7.3 TypeScript/JavaScript

**Keymaps:**
| Keymap | Action |
|--------|--------|
| `<leader>lI` | Organize imports |

**Requirements:**
- `ts_ls` LSP server (typescript-language-server)
- `prettierd` for formatting
- `eslint_d` for linting

---

## 8. Performance

### Startup Time

Target: **< 30ms**

Measure with:
```bash
nvim --startuptime /tmp/nvim-startup.log +q
sort -k2 -n /tmp/nvim-startup.log | head -20
```

### Lazy Loading

All plugins use lazy loading via:
- `event` - Load on specific event (BufReadPost, InsertEnter, etc.)
- `ft` - Load on specific filetype
- `cmd` - Load when command is called

### Disabled Built-ins

In `options.lua`:
```lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
```

### Large File Handling

Auto-detected in `autocmds.lua`:
- Files > 1MB disable:
  - Syntax highlighting
  - Treesitter
  - Undo files

### Completion Performance

- `keyword_length = 1` for LSP (immediate completions)
- `throttle = 0` for instant responses
- `max_item_count = 100` for LSP, `20` for snippets
- `priority_weight = 2` for better sorting

---

## 9. Troubleshooting

### Check Health

```vim
:checkhealth             " All health checks
:checkhealth vim.lsp     " LSP specifically
:checkhealth treesitter  " Treesitter
:checkhealth vim.pack    " Plugin manager
```

### LSP Issues

```vim
:LspInfo                 " Show LSP status for current buffer
:lua vim.print(vim.lsp.get_clients())  " All active clients
```

**Common fixes:**
- Ensure server binary is in PATH: `which gopls`, `which rust-analyzer`
- Restart LSP: `:LspRestart`
- Check server config name matches exactly

### Completion Issues

```vim
:CmpStatus              " Show completion status
:lua require('cmp').setup({...})  " Debug completion config
```

**Check if cmp is loaded:**
```vim
:lua print(vim.inspect(require('cmp')))
```

### Treesitter Issues

```vim
:TSInstall <language>    " Install parser
:Inspect                 " Show highlight groups under cursor
:InspectTree             " Show treesitter parse tree
```

### Keymaps Not Working

Check if plugin loaded:
```vim
:lua print(vim.inspect(vim.fn.maparg('<leader>ff', 'n')))
```

### Plugin Not Loading

Check vim.pack status:
```vim
:lua for _,p in ipairs(vim.pack.get()) do print(p.name, p.enabled) end
```

### Common Errors

**"attempt to call field 'install' (a nil value)"**
- `vim.pack.install()` doesn't exist, use `vim.pack.update()`

**LSP not attaching**
- Check `:LspInfo` for reason
- Verify PATH contains LSP binary

**Treesitter not highlighting**
- Run `:TSInstall <lang>` for missing parser
- Check `:Inspect` for highlight source

**"Do not require 'mini' directly"**
- Fixed by requiring mini submodules directly (mini.comment, mini.ai, mini.move)

**Headless plugin update timeout**
- Use: `GIT_TERMINAL_PROMPT=0 nvim --headless "+lua vim.pack.update()" +qa`

---

## Configuration Files Summary

| File | Purpose |
|------|---------|
| `init.lua` | Entry point |
| `core/options.lua` | All vim.opt settings |
| `core/keymaps.lua` | Global keymaps |
| `core/autocmds.lua` | Autocommands |
| `core/pack.lua` | Plugin registration |
| `plugins/lsp.lua` | LSP configuration |
| `plugins/treesitter.lua` | Treesitter setup |
| `plugins/ui.lua` | Theme registration + picker |
| `plugins/fuzzy.lua` | fzf-lua setup |
| `plugins/git.lua` | gitsigns setup |
| `plugins/editing.lua` | surround, autopairs, mini |
| `plugins/explorer.lua` | neo-tree.nvim |
| `plugins/formatting.lua` | conform.nvim |
| `plugins/linting.lua` | nvim-lint |
| `plugins/cmp.lua` | nvim-cmp completion |
| `plugins/lang/go.lua` | Go-specific |
| `plugins/lang/rust.lua` | Rust-specific |
| `plugins/lang/ts.lua` | TS-specific |
| `themes/init.lua` | Theme module (register/list/apply) |
| `themes/kanagawa.lua` | Kanagawa dragon config |
| `themes/pywal.lua` | Pywal16 config |
| `util/statusline.lua` | Custom statusline |

---

*Guide version: May 2026 | Target: NVIM v0.13.0-dev-440+g9174157f74*