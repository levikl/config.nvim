return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<M-h>"] = "actions.select_split",
        },
        view_options = {
          show_hidden = true,

          -- Permanently hide specific files and directories
          is_always_hidden = function(name, bufnr)
            -- Use a lookup table for exact directory/file name matches (O(1) lookup)
            local hidden_names = {
              node_modules = true,
              bin = true,
              obj = true,
              build = true,
              dist = true,
              ["test-results"] = true,
            }

            -- Return true if it's in the exact match table OR if it ends with .meta
            return hidden_names[name] or vim.endswith(name, ".meta")
          end,
        },
      }

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
