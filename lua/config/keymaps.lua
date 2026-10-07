-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open current file in Windows File Explorer (WSL: explorer.exe, Linux: xdg-open)
-- NOTE: <leader>fe is taken by LazyVim Explorer (neo-tree/snacks); <leader>fo (file open) it is
vim.keymap.set("n", "<leader>fo", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = vim.fn.getcwd()
  end
  local is_dir = vim.fn.isdirectory(path) == 1
  if vim.fn.has("wsl") == 1 then
    local win_path = vim.fn.systemlist({ "wslpath", "-w", path })[1]
    if vim.v.shell_error ~= 0 or win_path == nil or win_path == "" then
      vim.notify("wslpath convert failed: " .. path, vim.log.levels.ERROR)
      return
    end
    if is_dir then
      vim.fn.jobstart({ "explorer.exe", win_path }, { detach = true })
    else
      vim.fn.jobstart({ "explorer.exe", "/select," .. win_path }, { detach = true })
    end
  else
    local open_path = is_dir and path or vim.fn.fnamemodify(path, ":h")
    vim.fn.jobstart({ "xdg-open", open_path }, { detach = true })
  end
end, { desc = "Reveal in File Explorer" })

-- browsh: 纯文本现代浏览器，运行在浮动终端中
vim.keymap.set("n", "<leader>bb", function()
  require("browsh").open()
end, { desc = "Browsh 浏览器（打开首页）" })

vim.keymap.set("n", "<leader>bbu", function()
  vim.ui.input({ prompt = "Browsh URL: ", default = "https://", completion = "url" }, function(url)
    if url and url ~= "" then
      require("browsh").open(url)
    end
  end)
end, { desc = "Browsh 浏览器（打开网址）" })

-- use jk to enter normal mode
vim.keymap.set({ "i", "v", "x", "s" }, "jk", "<Esc>", { desc = "enter normal mode" })
