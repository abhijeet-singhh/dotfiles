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

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('lua_ls', {
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
    },
  },
})

vim.api.nvim_create_user_command("LspInfo", function()
  local clients = vim.lsp.get_clients()
  print("Active LSP clients:")
  if #clients == 0 then
    print("  (none)")
  else
    for _, client in ipairs(clients) do
      print("  - " .. client.name .. " (id: " .. client.id .. ")")
    end
  end
end, {})

vim.api.nvim_create_user_command("LspRestart", function()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    client:stop()
  end
end, {})

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd("edit " .. vim.fn.stdpath("log") .. "/lsp.log")
end, {})

vim.api.nvim_create_user_command("LspDebug", function()
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    print("  " .. client.name .. ": id=" .. client.id)
  end
end, {})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user_lsp_auto_start', { clear = true }),
  pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'rust', 'go' },
  callback = function()
    local ft = vim.bo.filetype
    local configs = {
      typescript = { name = 'ts_ls', cmd = { "/home/abhijeet/.nvm/versions/node/v22.19.0/bin/typescript-language-server", "--stdio" }, root = { "package.json", "tsconfig.json", ".git" } },
      javascript = { name = 'ts_ls', cmd = { "/home/abhijeet/.nvm/versions/node/v22.19.0/bin/typescript-language-server", "--stdio" }, root = { "package.json", ".git" } },
      typescriptreact = { name = 'ts_ls', cmd = { "/home/abhijeet/.nvm/versions/node/v22.19.0/bin/typescript-language-server", "--stdio" }, root = { "package.json", "tsconfig.json", ".git" } },
      javascriptreact = { name = 'ts_ls', cmd = { "/home/abhijeet/.nvm/versions/node/v22.19.0/bin/typescript-language-server", "--stdio" }, root = { "package.json", ".git" } },
      rust = { name = 'rust_analyzer', cmd = { "/home/abhijeet/.cargo/bin/rust-analyzer" }, root = { "Cargo.toml", "Cargo.lock", ".git" } },
      go = { name = 'gopls', cmd = { "/home/abhijeet/go/bin/gopls" }, root = { "go.mod", ".git" } },
    }
    local config = configs[ft]
    if config then
      for _, client in ipairs(vim.lsp.get_clients({ name = config.name })) do
        return
      end
      local root = vim.fs.find(config.root, { upward = true })[1]
      if root then
        vim.lsp.start({
          name = config.name,
          cmd = config.cmd,
          root_dir = root,
          capabilities = lsp_capabilities,
        })
      end
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