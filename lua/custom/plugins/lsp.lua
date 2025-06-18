return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- this plugin adds `vim` global var to Lua LSP, among other things
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files [ft=filetype]
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    },
    config = function()
      require("lspconfig").lua_ls.setup {}

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Auto-format ("lint") on save.
          -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
          if not client:supports_method('textDocument/willSaveWaitUntil')
              and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end,
      })

      require("lsp_lines").setup()
      vim.diagnostic.config { virtual_text = true, virtual_lines = false }

      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp_lines" })
    end,
  }
}
