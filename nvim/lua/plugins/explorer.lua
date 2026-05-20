require('neo-tree').setup({
  close_if_last_window = true,
  enable_diagnostics = true,
  enable_git_status = true,
  enable_modified_markers = true,
  enable_refresh_on_write = true,
  sort_case_insensitive = false,
  default_component_configs = {
    indent = { indent_size = 2, with_markers = true },
    icon = { default = '', folder_empty = '󰜌' },
    git_status = { symbols = { added = '', modified = '', deleted = '✖', renamed = '󰁕', untracked = '󰊓', ignored = '󰀃', unstaged = '󰄱', staged = '󰄭', conflict = '󰅓' } },
    name = { trailing_slash = true },
    symlink = { enabled = true },
    file_size = { enabled = true, required_width = 60 },
    type = { enabled = true, required_width = 60 },
    modified = { enabled = true, required_width = 80 },
    created = { enabled = true, required_width = 80 },
  },
  window = { position = 'left', width = 35, mapping_options = { noremap = true, nowait = true } },
  default_source = 'filesystem',
  filesystem = {
    bind_to_cwd = false,
    follow_tail = true,
    use_libuv_file_watcher = true,
    filtered_items = { visible = false, hide_dotfiles = true, hide_gitignored = false },
    window = { mappings = { ['<S-CR>'] = 'toggle_node', ['<2-LeftMouse>'] = 'open', ['<CR>'] = 'open', ['<Tab>'] = 'toggle_node', ['h'] = 'navigate_up', ['.'] = 'set_root', ['u'] = 'navigate_up', ['-'] = 'navigate_up', ['/'] = 'fuzzy_finder', ['f'] = 'filter_on_submit', ['F'] = 'clear_filter', ['[c'] = 'prev_git_modified', [']c'] = 'next_git_modified' } },
  },
  document_source = { enabled = true, window = { mappings = { ['<CR>'] = 'open' } } },
  event_handlers = { { event = 'file_open', handler = function() vim.cmd('Neotree close') end } },
})

vim.keymap.set('n', '-', '<cmd>Neotree filesystem toggle<cr>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>e', '<cmd>Neotree filesystem toggle<cr>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>o', '<cmd>Neotree outline toggle<cr>', { desc = 'Toggle outline' })

vim.keymap.set('n', 'q', function()
  local ok, neo_tree = pcall(require, 'neo-tree')
  if ok then
    local state = require('neo-tree.sources.manager').state
    if state then vim.cmd('Neotree close') end
  end
  vim.cmd('close')
end, { desc = 'Close explorer' })