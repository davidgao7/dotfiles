local treesitter_opts = {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
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
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader> ",
      node_incremental = "<leader> ",
      scope_incremental = "<leader>q",
      node_decremental = "<BS>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
        ["ii"] = "@conditional.inner",
        ["ai"] = "@conditional.outer",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        ["iv"] = "@parameter.inner",
        ["av"] = "@parameter.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]l"] = "@loop.outer",
        ["]i"] = "@conditional.outer",
        ["]b"] = "@block.outer",
        ["]p"] = "@parameter.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]L"] = "@loop.outer",
        ["]I"] = "@conditional.outer",
        ["]B"] = "@block.outer",
        ["]P"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[l"] = "@loop.outer",
        ["[i"] = "@conditional.outer",
        ["[b"] = "@block.outer",
        ["[p"] = "@parameter.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[L"] = "@loop.outer",
        ["[I"] = "@conditional.outer",
        ["[B"] = "@block.outer",
        ["[P"] = "@parameter.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = { ["<leader>sp"] = "@parameter.inner" },
      swap_previous = { ["<leader>sP"] = "@parameter.inner" },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- 1. FORCE STABLE BRANCH
    branch = "master",
    build = ":TSUpdate",
    -- 2. DISABLE LAZY LOADING to prevent race conditions during startup
    lazy = false,
    init = function(plugin)
      -- This ensures queries are available even if other plugins load weirdly
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = treesitter_opts,
    config = function(_, opts)
      -- 3. STANDARD SETUP (Restores configs module)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    -- 4. SIMPLIFIED CONFIG
    -- We don't need manual config here because we passed the 'textobjects' table
    -- to the main treesitter setup above. That is the robust standard way.
    lazy = true,
    event = "VeryLazy",
  },

  {
    "windwp/nvim-ts-autotag",
    -- 5. FIX EVENT ERROR
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
