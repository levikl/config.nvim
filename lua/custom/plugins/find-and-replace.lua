return {
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup {
        -- options, see :h grug-far-opts
      }
    end,
    keys = {
      { "<leader>fr", "<cmd>GrugFar<CR>", desc = "Search and Replace (Project)" },
    },
  },
}
