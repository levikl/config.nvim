return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        -- markdown = { "vale" },
        go = { "golangcilint" },
      }

      -- vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
