vim.loader.enable()
vim.opt.lazyredraw = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes:1'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.cmdheight = 1
vim.opt.pumheight = 10

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.grepprg = 'rg --vimgrep --smart-case --follow'
vim.opt.grepformat = '%f:%l:%c:%m'

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt.undofile = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true

vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert', 'fuzzy' }
vim.opt.shortmess:append('c')

vim.opt.clipboard = 'unnamedplus'

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevelstart = 99

vim.opt.updatetime = 100
vim.opt.timeoutlen = 1000
vim.opt.confirm = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1