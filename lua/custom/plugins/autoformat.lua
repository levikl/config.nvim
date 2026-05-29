return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        lua = { "stylua" },
        cs = { "cshittier" },
        kotlin = { "ktlint" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        -- php = { "php_cs_fixer" },
        blade = { "blade-formatter" },
        -- python = { "isort", "black" },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        -- json = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        less = { "prettierd", "prettier", stop_after_first = true },
        postcss = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        svelte = { "prettierd", "prettier", stop_after_first = true },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_after_save = {
        lsp_fallback = true,
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        cshittier = {
          command = "/home/levi/ws/cs/dn10/cshittier/my-csharpier/CSharpier",
          args = {
            "format",
            "--write-stdout",
          },
          to_stdin = true,
        },
        -- golines = {
        --   prepend_args = { "--max-len=80" },
        -- },
      },
    },
    -- init = function()
    --   -- If you want the formatexpr, here is the place to set it
    --   vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    -- end,
  },
}
