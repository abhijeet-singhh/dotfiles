require('lint').linters_by_ft = {
  go = { 'golangcilint' },
  typescript = { 'eslint_d' },
  javascript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  sh = { 'shellcheck' },
  dockerfile = { 'hadolint' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
  callback = function()
    if not vim.b.large_file then
      require('lint').try_lint()
    end
  end,
})