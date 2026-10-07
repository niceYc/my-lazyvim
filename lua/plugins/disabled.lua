---禁用 LazyVim 自带的插件
---放在这里的插件会被覆盖为 enabled = false，不再被 lazy 加载/安装。
---LazyVim 依赖其中少数插件（如 lspconfig、snacks），除非确认不需要，否则不要禁用。
return {
  -- Markdown 终端内渲染（标题加粗/代码块/链接等）
  -- 由 lazyvim.plugins.extras.lang.markdown 引入，
  -- 同时被 elixir / avante extra 引用
  -- { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
}
