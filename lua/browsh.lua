---@brief browsh 浮动终端封装
local M = {}

local TITLE = " Browsh "

---@param url? string
function M.open(url)
  if vim.fn.executable("browsh") ~= 1 then
    vim.notify("未找到 browsh，请先安装到 PATH 中", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable("firefox") ~= 1 and vim.fn.executable("firefox-esr") ~= 1 then
    vim.notify("未找到 firefox，browsh 需要 firefox 57+ 才能渲染页面", vim.log.levels.WARN)
  end

  local cmd = { "browsh" }
  if url and url ~= "" then
    cmd = { "browsh", "--startup-url", url }
  end

  local width = math.max(vim.o.columns - 6, 40)
  local height = math.max(vim.o.lines - 8, 10)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2) - 1,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = TITLE,
    title_pos = "center",
    noautocmd = true,
  })

  vim.wo[win].number = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].wrap = false

  vim.fn.termopen(cmd, {
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  vim.api.nvim_buf_set_name(buf, "term://browsh")
  vim.bo[buf].buflisted = false
  vim.api.nvim_set_current_win(win)
  vim.cmd.startinsert()
end

return M
