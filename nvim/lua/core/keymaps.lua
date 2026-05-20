vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

map('v', '<', '<gv')
map('v', '>', '>gv')

map('v', '<A-j>', ":m '>+1<cr>gv=gv")
map('v', '<A-k>', ":m '<-2<cr>gv=gv")

map('v', 'p', '"_dP')

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map('n', '<C-Up>',    ':resize +2<cr>')
map('n', '<C-Down>',  ':resize -2<cr>')
map('n', '<C-Left>',  ':vertical resize -2<cr>')
map('n', '<C-Right>', ':vertical resize +2<cr>')

map('n', '<S-h>', ':bprevious<cr>')
map('n', '<S-l>', ':bnext<cr>')
map('n', '<leader>bd', ':bdelete<cr>', { desc = 'Delete buffer' })
map('n', '<leader>bD', ':bdelete!<cr>', { desc = 'Force delete buffer' })
map('n', '<leader>bb', '<cmd>FzfLua buffers<cr>', { desc = 'Pick buffer' })
map('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      if ft ~= 'neo-tree' and ft ~= 'NvimTree' then
        vim.cmd('bdelete! ' .. buf)
      end
    end
  end
end, { desc = 'Close other buffers' })
map('n', '<leader>`', '<cmd>buffer#<cr>', { desc = 'Jump to last buffer' })

vim.cmd('nnoremap <leader>1 <cmd>BufferLineGoToBuffer 1<cr>')
vim.cmd('nnoremap <leader>2 <cmd>BufferLineGoToBuffer 2<cr>')
vim.cmd('nnoremap <leader>3 <cmd>BufferLineGoToBuffer 3<cr>')
vim.cmd('nnoremap <leader>4 <cmd>BufferLineGoToBuffer 4<cr>')
vim.cmd('nnoremap <leader>5 <cmd>BufferLineGoToBuffer 5<cr>')
vim.cmd('nnoremap <leader>6 <cmd>BufferLineGoToBuffer 6<cr>')
vim.cmd('nnoremap <leader>7 <cmd>BufferLineGoToBuffer 7<cr>')
vim.cmd('nnoremap <leader>8 <cmd>BufferLineGoToBuffer 8<cr>')
vim.cmd('nnoremap <leader>9 <cmd>BufferLineGoToBuffer 9<cr>')

map('n', ']q', ':cnext<cr>')
map('n', '[q', ':cprev<cr>')
map('n', '<leader>q', ':copen<cr>', { desc = 'Open quickfix' })

map('n', '<Esc>', ':nohlsearch<cr>')

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<leader>th', function()
  vim.cmd('15split | terminal')
end, { desc = 'Terminal horizontal' })
map('n', '<leader>tv', ':vsplit | terminal<cr>', { desc = 'Terminal vertical' })
map('n', '<leader>tt', ':terminal<cr>', { desc = 'Terminal' })

vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true })

map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })