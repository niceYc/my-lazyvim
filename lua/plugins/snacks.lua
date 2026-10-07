return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.layouts = opts.picker.layouts or {}
      opts.picker.layouts.default = opts.picker.layouts.default or {}
      opts.picker.layouts.default.layout = opts.picker.layouts.default.layout or {}
      opts.picker.layouts.default.layout[2] = opts.picker.layouts.default.layout[2] or {}
      opts.picker.layouts.default.layout[2].win = "preview"
      opts.picker.layouts.default.layout[2].width = 0.65
      -- terminal 只占中间编辑区宽度，不压住左右工具栏
      -- opts.terminal = opts.terminal or {}
      -- opts.terminal.win = vim.tbl_deep_extend("force", opts.terminal.win or {}, {
      --   position = "bottom",
      --   relative = "win",
      -- })
    end,
  },
}
