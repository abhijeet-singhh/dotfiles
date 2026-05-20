vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust', 'toml' },
  callback = function()
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
    end
    map('<leader>lr', '<cmd>!cargo run<cr>', 'Rust: cargo run')
    map('<leader>lb', '<cmd>!cargo build<cr>', 'Rust: cargo build')
    map('<leader>lt', '<cmd>!cargo test<cr>', 'Rust: cargo test')
    map('<leader>lc', '<cmd>!cargo clippy<cr>', 'Rust: cargo clippy')
  end,
})