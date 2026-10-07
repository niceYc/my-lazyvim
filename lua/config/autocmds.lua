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

-- Attach sidekick CLI in the background (replace the tool name as needed)
local function attach_sidekick()
  vim.schedule(function()
    require("lazy").load({ plugins = { "sidekick.nvim" } })
    require("sidekick.cli.session").setup()
    local State = require("sidekick.cli.state")
    local Config = require("sidekick.config")
    local tool = Config.get_tool("opencode")
    local attached = State.get({ attached = true, name = tool.name })
    -- Re-show already-attached sessions of the same tool instead of opening a duplicate
    if #attached > 0 then
      for _, s in ipairs(attached) do
        State.attach(s, { show = true, focus = false })
      end
      return
    end
    State.attach({ tool = tool }, { show = true, focus = false })
  end)
end

local sidekick_autostart = vim.api.nvim_create_augroup("sidekick_autostart", { clear = true })

-- Open sidekick in the background on startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = sidekick_autostart,
  callback = attach_sidekick,
})

-- Re-attach sidekick after restoring a session (persistence.nvim)
vim.api.nvim_create_autocmd("User", {
  group = sidekick_autostart,
  pattern = "PersistenceLoadPost",
  callback = attach_sidekick,
})
