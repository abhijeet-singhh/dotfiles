local themes = require("themes")

themes.register("kanagawa", require("themes.kanagawa"))
themes.register("pywal", require("themes.pywal"))

themes.apply("kanagawa")

vim.keymap.set("n", "<leader>T", function()
  local items = themes.list()
  if #items == 0 then
    vim.notify("No themes found", vim.log.levels.WARN)
    return
  end

  local tmpfile = vim.fn.tempname()
  vim.fn.writefile(items, tmpfile)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 60,
    height = 14,
    row = math.floor((vim.o.lines - 14) / 2),
    col = math.floor((vim.o.columns - 60) / 2),
    style = "minimal",
    border = "rounded",
    title = " Themes ",
    title_pos = "center",
  })

  vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"

  vim.fn.termopen({"sh", "-c", "cat " .. tmpfile .. " | fzf --prompt='Themes> ' --layout=reverse --info=inline"}, {
    on_exit = function(_, code)
      os.remove(tmpfile)
      if code == 0 then
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local choice = vim.trim(lines[1] or "")
        if choice ~= "" then
          vim.schedule(function()
            themes.apply(choice)
            vim.notify("Theme: " .. choice, vim.log.levels.INFO, { title = "Theme Switcher" })
          end)
        end
      end
      pcall(vim.api.nvim_win_close, win, true)
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end,
  })
end, { desc = "Select colorscheme (fzf)" })
