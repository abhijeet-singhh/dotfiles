local augroup = function(name)
  return vim.api.nvim_create_augroup('user_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('yank_highlight'),
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('trim_whitespace'),
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('restore_cursor'),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('quick_close'),
  pattern = { 'help', 'man', 'qf', 'lspinfo', 'startuptime', 'checkhealth', 'neo-tree' },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = augroup('resize_splits'),
  callback = function() vim.cmd('tabdo wincmd =') end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('conceal'),
  pattern = { 'markdown', 'json' },
  callback = function() vim.opt_local.conceallevel = 2 end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  group = augroup('large_file'),
  callback = function(ev)
    local size = vim.fn.getfsize(ev.file)
    if size > 1024 * 1024 then
      vim.b.large_file = true
      vim.opt_local.syntax = 'off'
      vim.opt_local.filetype = ''
      vim.opt_local.undofile = false
      vim.notify('Large file: some features disabled', vim.log.levels.WARN)
    end
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup('terminal_insert'),
  callback = function() vim.cmd('startinsert') end,
})