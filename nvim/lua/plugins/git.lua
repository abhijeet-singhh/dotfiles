local gs = require('gitsigns')

gs.setup({
  signs = {
    add = { text = '│' },
    change = { text = '│' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { interval = 1000, follow_files = true },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = { virtual_text_pos = 'eol', delay = 1000 },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  update_debounce = 100,
  max_file_length = 40000,
  preview_config = { border = 'single', style = 'minimal', relative = 'cursor', row = 0, col = 1 },
  on_attach = function(buffer)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = 'Git: ' .. desc })
    end
    map('n', ']h', gs.next_hunk, 'Next hunk')
    map('n', '[h', gs.prev_hunk, 'Prev hunk')
    map({ 'n', 'v' }, '<leader>gh', ':Gitsigns stage_hunk<cr>', 'Stage hunk')
    map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<cr>', 'Reset hunk')
    map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
    map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
    map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
    map('n', '<leader>gd', gs.diffthis, 'Diff this')
    map('n', '<leader>gD', function() gs.diffthis('~') end, 'Diff this ~')
  end,
})