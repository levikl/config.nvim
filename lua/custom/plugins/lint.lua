return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        -- markdown = { "vale" },
        go = { "golangcilint" },
        php = { "phpstan" },
      }

      local phpstan = lint.linters.phpstan
      phpstan.cmd = "vendor/bin/phpstan"
      phpstan.args = {
        "analyze",
        "--error-format=json",
        "--no-progress",
        "--memory-limit=2G",
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
