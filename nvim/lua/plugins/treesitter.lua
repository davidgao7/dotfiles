local function is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@generic T
---@param list T[]
---@return T[]
local function dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

local treesitter_opts = {
  highlight = {
    enable = true,

    -- It controls whether Neovim's legacy regex-based syntax highlighting is enabled alongside Treesitter
    -- Tree-sitter is more accurate and modern than regex-based Vim syntax
    -- Enabling both can cause duplicate highlights, flickering, or mismatches
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  ensure_installed = {
    "bash",
    "c",
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
      -- start selection and expand
      init_selection = "<leader> ", -- <leader><Space>
      node_incremental = "<leader> ",
      -- shrink back
      node_decremental = "<BS>",
      -- you can still bind scope if you like:
      scope_incremental = "<leader>q",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- Loops
        ["il"] = "@loop.inner",
        ["al"] = "@loop.outer",
        -- Functions
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        -- Classes
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
        -- Conditionals (if/else)
        ["ii"] = "@conditional.inner",
        ["ai"] = "@conditional.outer",
        -- Blocks (anonymous blocks, e.g. `{ … }`)
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        -- Parameters
        ["ip"] = "@parameter.inner",
        ["ap"] = "@parameter.outer",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- add to jumplist
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
      swap_next = {
        ["<leader>sp"] = "@parameter.inner", -- swap with next argument
      },
      swap_previous = {
        ["<leader>sP"] = "@parameter.inner", -- swap with previous
      },
    },

    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["<leader>df"] = "@function.outer", -- peek function def
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<BS>", desc = "Decrement Selection", mode = "x" },
        { "<leader><Space>", desc = "Increment Selection", mode = { "x", "n" } },
      },
    },
  },

  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<leader><Space>", desc = "Increment Selection", mode = { "n", "x" } },
      { "<BS>", desc = "Decrement Selection", mode = "x" },
    },

    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = treesitter_opts,
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    enabled = true,
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if is_loaded("nvim-treesitter") then
        local opts = treesitter_opts
        require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
      end

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
}
