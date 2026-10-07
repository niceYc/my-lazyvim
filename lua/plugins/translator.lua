---@type LazySpec
return {
  "potamides/pantran.nvim",
  cmd = "Pantran",
  keys = {
    {
      "<leader>tr",
      function()
        return require("pantran").motion_translate()
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Pantran translate",
    },
  },
  opts = {
    default_engine = "google",
    engines = {
      google = {
        fallback = {
          default_source = "auto",
          default_target = "zh-CN",
        },
      },
    },
  },
}
