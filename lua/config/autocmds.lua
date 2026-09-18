-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--

-- Auto-switch input method (only takes effect in WSL)
-- Requires AIMSwitcher.exe on the Windows side
-- Does nothing on plain Linux
-- Only enable inside WSL when AIMSwitcher.exe is available
if vim.fn.has("wsl") == 1 and vim.fn.executable("/mnt/c/AIMSwitcher.exe") == 1 then
  -- Switch to English input method.
  local function set_english_ime()
    vim.system({ "/mnt/c/AIMSwitcher.exe", "--imm", "0" })
  end

  local ime_group = vim.api.nvim_create_augroup("my-config-ime", { clear = true })

  -- Always keep English IME regardless of mode, window, or buffer.
  vim.api.nvim_create_autocmd({
    "ModeChanged",
    "WinEnter",
    "BufEnter",
    "TermEnter",
    "TermLeave",
    "CmdlineEnter",
  }, {
    group = ime_group,
    callback = set_english_ime,
  })

  -- Also force English IME once the config has loaded.
  set_english_ime()
end

-- Open opencode in the background on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      require("lazy").load({ plugins = { "sidekick.nvim" } })
      require("sidekick.cli.session").setup()
      local State = require("sidekick.cli.state")
      local Config = require("sidekick.config")
      State.attach({ tool = Config.get_tool("opencode") }, { show = true, focus = false })
    end)
  end,
})
