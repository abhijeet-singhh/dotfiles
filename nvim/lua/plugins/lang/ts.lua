vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  callback = function()
    vim.keymap.set('n', '<leader>lI', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { 'source.organizeImports' }, diagnostics = {} },
      })
    end, { buffer = true, desc = 'TS: Organize imports' })
  end,
})