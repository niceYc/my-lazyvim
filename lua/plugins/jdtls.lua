return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.cmd = vim.list_extend({ "env", "JAVA_HOME=/usr/lib/jvm/java-21-openjdk" }, opts.cmd)
    end,
  },
}
