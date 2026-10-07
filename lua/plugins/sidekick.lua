return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        tools = {
          codex = {
            cmd = { "codex", "resume", "--last" },
            env = { TMUX = false, STY = false },
          },
          opencode = {
            cmd = { "opencode", "--continue" },
            env = { TMUX = false, STY = false },
          },
        },
        prompts = {
          commit = "分析工作区的全部改动代码，并根据改动内容生成一条或多条 commit message，要求 commit message 语义清晰、简洁明了、符合规范，且不超过 50 个字符",
          push = "分析工作区的全部改动代码，并根据改动内容生成一条或多条 commit message，要求 commit message 语义清晰、简洁明了、符合规范，且不超过 50 个字符,并且执行 git push 命令",
          genApidoc = "将刚才的改动代码生成一份提供给前端使用的 API 文档md格式文件并给出文件完整路径，要求接口说明中完整包括全部请求参数和返回值,并说明每个接口的使用场景",
        },
      },
    },
  },
}
