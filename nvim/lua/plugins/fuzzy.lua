local fzf = require('fzf-lua')

fzf.setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    border = 'rounded',
  },
  preview = {
    layout = 'split',
    vertical = 'up:50%',
    scrollbar = 'border:round:10%',
  },
  git = {
    status = { cmd = 'git status --porcelain' },
    commits = { cmd = 'git log --pretty=format:"%h %s" -n 100' },
    branches = { cmd = 'git branch -a' },
  },
  fzf_opts = {
    ['--preview-window'] = 'down:50%:border:none',
    ['--preview'] = 'bat --color=always --style=auto {2} 2>/dev/null || cat {2}',
  },
  keymap = {
    builtin = {
      ['<c-j>'] = 'down',
      ['<c-k>'] = 'up',
    },
  },
})

local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end
map('<leader>ff', fzf.files, 'Find: files')
map('<leader>fg', fzf.live_grep, 'Find: grep')
map('<leader>fb', fzf.buffers, 'Find: buffers')
map('<leader>fr', fzf.oldfiles, 'Find: recent')
map('<leader>fh', fzf.help_tags, 'Find: help')
map('<leader>fs', fzf.lsp_document_symbols, 'Find: symbols')
map('<leader>fS', fzf.lsp_workspace_symbols, 'Find: workspace symbols')
map('<leader>fw', fzf.grep_cword, 'Find: word under cursor')
map('<leader>fW', fzf.grep_cWORD, 'Find: WORD under cursor')
map('<leader>fc', fzf.blines, 'Find: in current buffer')
map('<leader>fd', fzf.diagnostics_document, 'Find: diagnostics')
map('<leader>fD', fzf.diagnostics_workspace, 'Find: workspace diagnostics')
map('<leader>fk', fzf.keymaps, 'Find: keymaps')
map('<leader>ft', fzf.treesitter, 'Find: treesitter nodes')
map('<leader>gl', fzf.git_commits, 'Git: log')
map('<leader>gL', fzf.git_bcommits, 'Git: buffer log')
map('<leader>gb', fzf.git_branches, 'Git: branches')
map('<leader>gs', fzf.git_status, 'Git: status')