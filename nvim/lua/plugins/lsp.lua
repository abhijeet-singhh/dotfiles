vim.diagnostic.config({
  underline = true,
  virtual_text = { spacing = 4, source = 'if_many', prefix = '●' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN]  = ' ',
      [vim.diagnostic.severity.HINT]  = '󰠠 ',
      [vim.diagnostic.severity.INFO]  = ' ',
    },
  },
  float = { border = 'rounded', source = true },
  update_in_insert = false,
  severity_sort = true,
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
      gofumpt = true,
      hints = {
        assignVariableTypes = true, compositeLiteralFields = true,
        compositeLiteralTypes = true, constantValues = true,
        functionTypeParameters = true, parameterNames = true, rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = 'clippy', extraArgs = { '--no-deps' } },
      procMacro = { enable = true },
      inlayHints = {
        bindingModeHints = { enable = true },
        closureReturnTypeHints = { enable = 'always' },
        lifetimeElisionHints = { enable = 'always', useParameterNames = true },
      },
    },
  },
})

vim.lsp.config('ts_ls', {
  settings = {
    typescript = { inlayHints = { includeInlayParameterNameHints = 'all', includeInlayFunctionParameterTypeHints = true, includeInlayVariableTypeHints = true, includeInlayReturnTypeHints = true } },
    javascript = { inlayHints = { includeInlayParameterNameHints = 'literals' } },
  },
})

vim.lsp.config('cssls', {})
vim.lsp.config('html', {})
vim.lsp.config('jsonls', {
  settings = { json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } } },
})
vim.lsp.config('yamlls', {})
vim.lsp.config('dockerls', {})
vim.lsp.config('bashls', {})
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--header-insertion=iwyu' },
})

vim.lsp.enable({
  'lua_ls', 'gopls', 'rust_analyzer', 'ts_ls',
  'cssls', 'html', 'jsonls', 'yamlls', 'dockerls', 'bashls', 'clangd',
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user_lsp_keymaps', { clear = true }),
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = 'LSP: ' .. desc })
    end
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', 'gr', vim.lsp.buf.references, 'References')
    map('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')
    map('n', 'K', vim.lsp.buf.hover, 'Hover docs')
    map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')
    map('i', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')
    map('n', '<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('v', '<leader>ca', vim.lsp.buf.code_action, 'Range code action')
    map('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format')
    map('n', '<leader>ci', vim.lsp.buf.incoming_calls, 'Incoming calls')
    map('n', '<leader>co', vim.lsp.buf.outgoing_calls, 'Outgoing calls')
    map('n', '<leader>cs', vim.lsp.buf.document_symbol, 'Document symbols')
    map('n', '<leader>cS', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
    map('n', '<leader>ch', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
    end, 'Toggle inlay hints')
  end,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })