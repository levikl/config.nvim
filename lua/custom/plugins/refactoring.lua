return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension "refactoring"
    end,
    -- stylua: ignore
    keys = {
      { "<leader>rs", mode = { "v" },   function() require("telescope").extensions.refactoring.refactors() end,                         desc = "Refactor", },
      { "<leader>ri", mode = {"n","v"}, function() return require("refactoring").refactor("Inline Variable") end,          expr = true, desc = "Inline Variable" },
      { "<leader>rb", mode = {"n"},     function() return require('refactoring').refactor('Exract Block') end,             expr = true, desc = "Extract Block" },
      { "<leader>rf", mode = {"n"},     function() return require('refactoring').refactor('Exract Block To File') end,     expr = true, desc = "Extract Block to File" },
      { "<leader>rP", mode = {"n"},     function() return require('refactoring').debug.printf({below = false}) end,        expr = true, desc = "Debug Print" },
      { "<leader>rp", mode = {"n"},     function() return require('refactoring').debug.print_var({normal = true}) end,     expr = true, desc = "Debug Print Variable" },
      { "<leader>rc", mode = {"n"},     function() return require('refactoring').debug.cleanup({}) end,                    expr = true, desc = "Debug Cleanup" },
      { "<leader>rf", mode = {"v"},     function() return require('refactoring').refactor('Extract Function') end,         expr = true, desc = "Extract Function" },
      { "<leader>rF", mode = {"v"},     function() return require('refactoring').refactor('Extract Function to File') end, expr = true, desc = "Extract Function to File" },
      { "<leader>rx", mode = {"v"},     function() return require('refactoring').refactor('Extract Variable') end,         expr = true, desc = "Extract Variable" },
      { "<leader>rp", mode = {"v"},     function() return require('refactoring').debug.print_var({}) end,                  expr = true, desc = "Debug Print Variable" },
    },
  },
}
