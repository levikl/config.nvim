return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
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
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local extend = function(name, key, values)
        local mod = require(string.format("lspconfig.configs.%s", name))
        local default = mod.default_config
        local keys = vim.split(key, ".", { plain = true })
        while #keys > 0 do
          local item = table.remove(keys, 1)
          default = default[item]
        end

        if vim.islist(default) then
          for _, value in ipairs(default) do
            table.insert(values, value)
          end
        else
          for item, value in pairs(default) do
            if not vim.tbl_contains(values, item) then
              values[item] = value
            end
          end
        end
        return values
      end

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      local servers = {
        -- bashls = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        -- },
        gopls = {
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        -- glsl_analyzer = true,
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  vim.fn.stdpath "data" .. "/lazy/plenary.nvim/lua",
                },
              },
            },
          },
        },
        -- rust_analyzer = true,
        -- svelte = true,
        -- intelephense = {
        --   settings = {
        --     intelephense = {
        --       format = {
        --         braces = "k&r",
        --       },
        --     },
        --   },
        -- },
        -- pyright = true,
        -- biome = true,
        -- astro = true,
        -- html = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        -- },
        -- emmet_ls = true,
        -- ts_ls = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        -- },
        -- tailwindcss = true,
        -- vtsls = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        -- },
        -- denols = true,
        -- jsonls = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        --   settings = {
        --     json = {
        --       schemas = require("schemastore").json.schemas(),
        --       validate = { enable = true },
        --     },
        --   },
        -- },
        -- cssls = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        -- },
        -- yamlls = {
        --   settings = {
        --     yaml = {
        --       schemaStore = {
        --         enable = false,
        --         url = "",
        --       },
        --       -- schemas = require("schemastore").yaml.schemas(),
        --     },
        --   },
        -- },
        -- gleam = {
        --   manual_install = true,
        -- },

        -- elixirls = {
        --   cmd = { "/home/tjdevries/.local/share/nvim/mason/bin/elixir-ls" },
        --   root_dir = require("lspconfig.util").root_pattern { "mix.exs" },
        --   -- server_capabilities = {
        --   --   -- completionProvider = true,
        --   --   definitionProvider = true,
        --   --   documentFormattingProvider = false,
        --   -- },
        -- },

        -- lexical = {
        --   cmd = { "/home/tjdevries/.local/share/nvim/mason/bin/lexical", "server" },
        --   root_dir = require("lspconfig.util").root_pattern { "mix.exs" },
        --   server_capabilities = {
        --     completionProvider = vim.NIL,
        --     definitionProvider = true,
        --   },
        -- },

        -- clangd = {
        --   -- cmd = { "clangd", unpack(require("custom.clangd").flags) },
        --   -- TODO: Could include cmd, but not sure those were all relevant flags.
        --   --    looks like something i would have added while i was floundering
        --   init_options = { clangdFileStatus = true },

        --   filetypes = { "c" },
        -- },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        -- "stylua",
        "lua_ls",
        "delve",
        -- "tailwind-language-server",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        -- lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local builtin = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
          vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
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
  },
}
