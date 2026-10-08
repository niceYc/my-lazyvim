--- 主题配置
--- 当前启用：tokyonight（在下方 opts.colorscheme 中修改）
--- 候选主题：tokyonight / catppuccin / dracula / onedark
--- 临时切换：:colorscheme dracula 或 <leader>uC
return {
  -- LazyVim 启动时加载的主题
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },

  -- Dracula
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
  },

  -- One Dark
  {
    "navarasu/onedark.nvim",
    lazy = false,
    opts = {
      -- 可选 style：dark / darker / cool / deep / warm / warmer / light
      style = "cool",
    },
  },
}
