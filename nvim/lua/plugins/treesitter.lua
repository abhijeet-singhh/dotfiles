require('nvim-treesitter.config').setup({
  ensure_installed = {
    'lua', 'vim', 'vimdoc', 'query',
    'go', 'gomod', 'gowork', 'gosum',
    'rust', 'toml',
    'typescript', 'tsx', 'javascript',
    'html', 'css', 'scss',
    'json', 'jsonc', 'yaml', 'toml',
    'bash', 'fish',
    'c', 'cpp',
    'python',
    'markdown', 'markdown_inline',
    'dockerfile', 'terraform', 'hcl',
    'sql',
    'regex',
    'comment',
    'diff',
    'git_config', 'gitignore', 'gitcommit',
  },
  highlight = { enable = true, disable = function(_, buf) return vim.b[buf].large_file end },
  indent = { enable = true, disable = { 'yaml' } },
  textobjects = {
    select = {
      enable = true, lookahead = true,
      keymaps = {
        ['af'] = '@function.outer', ['if'] = '@function.inner',
        ['ac'] = '@class.outer', ['ic'] = '@class.inner',
        ['aa'] = '@parameter.outer', ['ia'] = '@parameter.inner',
        ['ab'] = '@block.outer', ['ib'] = '@block.inner',
        ['al'] = '@loop.outer', ['il'] = '@loop.inner',
        ['ai'] = '@conditional.outer', ['ii'] = '@conditional.inner',
      },
    },
    move = {
      enable = true, set_jumps = true,
      goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
      goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
      goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
      goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
    },
    swap = { enable = true, swap_next = { ['<leader>a'] = '@parameter.inner' }, swap_previous = { ['<leader>A'] = '@parameter.inner' } },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>', node_incremental = '<C-space>', scope_incremental = '<C-s>', node_decremental = '<bs>',
    },
  },
})