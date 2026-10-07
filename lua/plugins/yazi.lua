---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    {
      "<leader>yz",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Yazi at current file",
    },
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Yazi in nvim cwd",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume yazi",
    },
  },
  ---@type YaziConfig | {}
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
