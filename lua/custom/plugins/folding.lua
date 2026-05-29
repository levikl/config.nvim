return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
      vim.opt.foldcolumn = "1" -- shows the chevrons in the gutter
      vim.opt.foldlevel = 99 -- standard ufo requirement
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.opt.mouse = "a" -- allows clicking the chevrons

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      }

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end,
  },
}
