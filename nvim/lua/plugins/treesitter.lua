local ensure_installed = {
  "bash",
  "c",
  "cmake",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "rust",
  "ron",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    -- The new plugin exports setup() from the top-level module
    main = "nvim-treesitter",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      -- Directory to install parsers (0.12 pattern)
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
    init = function()
      -- Enable highlighting and indentation via autocmd (Neovim 0.12 pattern)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          local ok, ts = pcall(require, "nvim-treesitter")
          if ok and ts.indentexpr then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      
      -- Manual installation of missing parsers
      local ts_config = require("nvim-treesitter.config")
      local already_installed = ts_config.get_installed and ts_config.get_installed() or {}
      local to_install = {}
      for _, p in ipairs(ensure_installed) do
        if not vim.tbl_contains(already_installed, p) then
          table.insert(to_install, p)
        end
      end
      
      if #to_install > 0 then
        ts.install(to_install)
      end

      ts.setup(opts)
    end,
  },

  -- Temporarily disabled due to incompatibility with Treesitter main branch rewrite
  -- {
  --   "windwp/nvim-ts-autotag",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = {},
  -- },

  -- Temporarily disabled due to incompatibility with Treesitter main branch rewrite
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   event = "BufReadPost",
  --   opts = {
  --     enable = true,
  --     max_lines = 5,
  --     zindex = 20,
  --   },
  -- },
}
