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

      -- Schema information
      "b0o/SchemaStore.nvim",

      {
        "seblyng/roslyn.nvim",
        ft = { "cs", "razor" },
        dependencies = {
          { "tris203/rzls.nvim", config = true },
        },
        config = function()
          local mason_registry = require "mason-registry"

          local rzls_path = vim.fn.expand "$MASON/packages/rzls/libexec"
          local cmd = {
            "roslyn",
            "--stdio",
            "--logLevel=Information",
            "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
            "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
            "--razorDesignTimePath="
              .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
            "--extension",
            vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
          }

          vim.lsp.config("roslyn", {
            cmd = cmd,
            handlers = require "rzls.roslyn_handlers",
            settings = {
              ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,

                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
              },
              ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
              },
            },
          })
          vim.lsp.enable "roslyn"
        end,
        init = function()
          vim.filetype.add {
            extension = {
              razor = "razor",
              cshtml = "razor",
            },
          }
        end,
      },
    },
    config = function()
      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      local function get_intelephense_license()
        local f = io.open(os.getenv "HOME" .. "/intelephense/license.txt", "r")
        if f then
          local license = f:read "*l"
          f:close()
          return license
        end
        return ""
      end

      local servers = {
        bashls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
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
              telemetry = { enable = false },
              diagnostics = {
                disable = { "missing-fields" },
              },
            },
          },
        },
        -- rust_analyzer = true,
        svelte = true,
        intelephense = {
          init_options = {
            licenceKey = get_intelephense_license(),
          },
          settings = {
            intelephense = {
              format = {
                enable = false,
              },
            },
          },
        },
        -- pyright = true,
        eslint = true,
        -- biome = true,
        astro = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
        html = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
        emmet_ls = true,
        ts_ls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
        tailwindcss = true,
        -- vtsls = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        -- },
        -- denols = true,
        jsonls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        cssls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
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
        gleam = {
          manual_install = true,
        },
        -- kotlin = {
        --   manual_install = true,
        -- },
        -- kotlin_language_server = true,

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

      require("mason").setup {
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      }
      local ensure_installed = {
        "stylua",
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

        vim.lsp.config[name] = config
        vim.lsp.enable(name)
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
    end,
  },
  {
    "AlexandrosAlexiou/kotlin.nvim",
    pin = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("kotlin").setup {
        -- This plugin handles the LSP attachment directly,
        -- bypassing standard mason-lspconfig
      }
    end,
  },
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    keys = {
      {
        "<leader>la",
        function()
          require("laravel").commands.run "artisan"
        end,
        desc = "Laravel Artisan",
      },
      {
        "<leader>lr",
        function()
          require("laravel").commands.run "route:list"
        end,
        desc = "Laravel Routes",
      },
      {
        "<leader>lm",
        function()
          require("laravel").commands.run "make:controller"
        end,
        desc = "Make Controller",
      },
    },
    config = function()
      require("laravel").setup()
    end,
  },
}
