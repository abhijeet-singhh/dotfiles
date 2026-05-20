require('go').setup({
  goimport = 'gopls',
  gofmt = 'gopls',
  max_line_len = 120,
  tag_transform = false,
  test_dir = '',
  comment_placeholder = '   ',
  icons = { breakpoint = '🧘', currentpos = '🏃' },
  lsp_cfg = false,
  lsp_gofumpt = true,
  lsp_on_attach = false,
  dap_debug = true,
  dap_debug_keymap = false,
  textobjects = false,
  run_in_floaterm = false,
  trouble = false,
  lsp_inlay_hints = { enable = false },
})

local go_keys = vim.api.nvim_create_augroup('go_keymaps', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = go_keys,
  pattern = 'go',
  callback = function()
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
    end
    map('<leader>lr', '<cmd>GoRun<cr>', 'Go: Run')
    map('<leader>lt', '<cmd>GoTest<cr>', 'Go: Test')
    map('<leader>lT', '<cmd>GoTestFile<cr>', 'Go: Test file')
    map('<leader>lc', '<cmd>GoCoverage<cr>', 'Go: Coverage')
    map('<leader>li', '<cmd>GoImport<cr>', 'Go: Add import')
    map('<leader>la', '<cmd>GoAlt<cr>', 'Go: Alternate (test file)')
    map('<leader>lf', '<cmd>GoFillStruct<cr>', 'Go: Fill struct')
    map('<leader>le', '<cmd>GoIfErr<cr>', 'Go: Add if err')
    map('<leader>lt', '<cmd>GoAddTag<cr>', 'Go: Add struct tags')
  end,
})