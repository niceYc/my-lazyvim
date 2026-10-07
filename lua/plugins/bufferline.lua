---bufferline 布局调整
---LazyVim 默认给 bufferline 配了 offsets = { { filetype = "snacks_layout_box" } }，
---左侧 snacks 侧边栏（explorer）出现时，tabline 左边会补一段等宽空白，
---看起来就像"左边 explorer 一整块、右边 buffer+编辑区+sidekick 另一整块"。
---清空 offsets，让 bufferline 恢复成横跨整行的顶部栏：
---  [ --------- bufferline --------- ]
---  [ explorer | 编辑区 | sidekick  ]
return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.offsets = {}
    end,
  },
}
