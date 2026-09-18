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
      },
    },
  },
}
