return {
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    ---@type gopher.Config
    opts = {},
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    -- (optional) will update plugin's deps on every update
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}
