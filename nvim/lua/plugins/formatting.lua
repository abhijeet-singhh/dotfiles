require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    go = { 'goimports', 'gofmt' },
    rust = { 'rustfmt' },
    typescript = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    javascript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    css = { 'prettierd' },
    html = { 'prettierd' },
    json = { 'prettierd' },
    yaml = { 'prettierd' },
    markdown = { 'prettierd' },
    sh = { 'shfmt' },
    ['_'] = { 'trim_whitespace' },
  },
  format_on_save = function(bufnr)
    if vim.b[bufnr].large_file then return end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
})

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format' })