return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- The critical fix for Neovim nightly
    build = ":TSUpdate",
    config = function()
      -- 1. Explicitly install your requested parsers
      require("nvim-treesitter").install {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "c_sharp",
        "typescript",
        "html",
        "css",
        "query",
        "markdown",
        "markdown_inline",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local max_filesize = 100 * 1024 -- 100 KB

          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))

          if ok and stats and stats.size > max_filesize then
            -- File is too large. Return early and let standard regex syntax take over.
            return
          end

          -- Start treesitter highlighting
          pcall(vim.treesitter.start, buf)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_indent", { clear = true }),
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
