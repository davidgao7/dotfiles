local clangd_ext_opts = {
  ast = {
    --These require codicons (https://github.com/microsoft/vscode-codicons)
    role_icons = {
      type = "",
      declaration = "",
      expression = "",
      specifier = "",
      statement = "",
      ["template argument"] = "",
    },
    kind_icons = {
      Compound = "",
      Recovery = "",
      TranslationUnit = "",
      PackExpansion = "",
      TemplateTypeParm = "",
      TemplateTemplateParm = "",
      TemplateParamObject = "",
    },
  },
}

local blink_kind_icons_set_one = {
  Text = "󰉿",
  Method = "󰊕",
  Function = "󰊕",
  Constructor = "󰒓",

  Field = "󰜢",
  Variable = "󰆦",
  Property = "󰖷",

  Class = "󱡠",
  Interface = "󱡠",
  Struct = "󱡠",
  Module = "󰅩",

  Unit = "󰪚",
  Value = "󰦨",
  Enum = "󰦨",
  EnumMember = "󰦨",

  Keyword = "󰻾",
  Constant = "󰏿",

  Snippet = "󱄽",
  Color = "󰏘",
  File = "󰈔",
  Reference = "󰬲",
  Folder = "󰉋",
  Event = "󱐋",
  Operator = "󰪚",
  TypeParameter = "󰬛",

  Copilot = "",

  openPR = "",
  openedPR = "",
  closedPR = "",
  mergedPR = "",
  draftPR = "",
  lockedPR = "",
  openIssue = "",
  openedIssue = "",
  reopenedIssue = "",
  completedIssue = "",
  closedIssue = "",
  not_plannedIssue = "",
  duplicateIssue = "",
  lockedIssue = "",
}

local completion_menu_highlight_groups = {
  BlinkCmpKindFunction = { fg = "#89b4fa" }, -- soft blue
  BlinkCmpKindMethod = { fg = "#89b4fa" }, -- soft blue (shared)
  BlinkCmpKindVariable = { fg = "#f9e2af" }, -- soft yellow
  BlinkCmpKindClass = { fg = "#f38ba8" }, -- soft pink
  BlinkCmpKindInterface = { fg = "#a6e3a1" }, -- soft green
  BlinkCmpKindModule = { fg = "#94e2d5" }, -- soft teal
  BlinkCmpKindKeyword = { fg = "#cba6f7" }, -- soft mauve
  BlinkCmpKindField = { fg = "#fab387" }, -- soft peach
  BlinkCmpKindProperty = { fg = "#f2cdcd" }, -- rosewater
  BlinkCmpKindEnum = { fg = "#fab387" }, -- peach
  BlinkCmpKindSnippet = { fg = "#f5c2e7" }, -- pink
  BlinkCmpKindFile = { fg = "#cdd6f4" }, -- white
  BlinkCmpKindFolder = { fg = "#b4befe" }, -- pastel blue
  BlinkCmpKindEvent = { fg = "#f9e2af" }, -- yellow
  BlinkCmpKindOperator = { fg = "#89b4fa" }, -- blue
  BlinkCmpKindTypeParameter = { fg = "#f5c2e7" }, -- pink
  BlinkCmpKindCopilot = { fg = "#94e2d5" }, -- teal (for Copilot suggestion)
  BlinkCmpKindOpenPR = { fg = "#89dceb" }, -- cyan
  BlinkCmpKindClosedPR = { fg = "#f38ba8" }, -- pink
  BlinkCmpKindMergedPR = { fg = "#a6e3a1" }, -- green
  BlinkCmpKindDraftPR = { fg = "#fab387" }, -- peach
  BlinkCmpKindLockedPR = { fg = "#f38ba8" }, -- pink
  BlinkCmpKindOpenIssue = { fg = "#89b4fa" }, -- blue
  BlinkCmpKindClosedIssue = { fg = "#f38ba8" }, -- pink
  BlinkCmpKindDuplicateIssue = { fg = "#fab387" }, -- peach
  BlinkCmpKindLockedIssue = { fg = "#f38ba8" }, -- pink
}

return {
  -- Core Treesitter functionality and parser management
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- Use version = false to stay up-to-date, or pin to a specific tag/commit
    build = ":TSUpdateSync", -- Compile parsers synchronously on install/update
    dependencies = {
      -- Required for enhanced text objects
      "nvim-treesitter/nvim-treesitter-textobjects",

      -- Add other Treesitter plugins here if you use them, e.g.:
      {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        opts = {
          enable = true,
          max_lines = 0, -- No limit on context lines shown
          trim_scope = "outer", -- Discard outer context when space is limited
          mode = "cursor", -- Use the cursor position to determine context
          line_numbers = true,
          multiline_threshold = 20,
          separator = nil, -- You can set this to "─" if you want a visual line
          zindex = 20,
        },
      }, -- Recommended for scope_incremental keymap below
      -- 'windwp/nvim-ts-autotag',
    },

    -- `opts` configures the runtime behavior and functionality of treesitter modules
    opts = {
      -- Ensure parsers for your commonly used languages are installed proactively
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "typescript",
        "python",
        "rust",
        "go",
        "html",
        "css",
        "markdown",
        "bash",
        "json",
        "yaml",
        -- Add any other languages you frequently use
      },

      -- Automatically install parsers for new languages the first time you open them
      -- Requires a compiler (gcc/clang/etc) and git to be installed.
      auto_install = true,

      -- Enable syntax highlighting using Treesitter
      highlight = {
        enable = true,
        -- additional_vim_regex_highlighting = false, -- Consider disabling if performance issues
      },

      -- Enable indentation using Treesitter
      indent = {
        enable = true,
      },

      -- Configure nvim-treesitter-textobjects: Defines *what* the text objects do
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "outer function (TS)" },
            ["if"] = { query = "@function.inner", desc = "inner function (TS)" },
            ["ac"] = { query = "@class.outer", desc = "outer class (TS)" },
            ["ic"] = { query = "@class.inner", desc = "inner class (TS)" },
            ["aa"] = { query = "@parameter.outer", desc = "outer argument (TS)" },
            ["ia"] = { query = "@parameter.inner", desc = "inner argument (TS)" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "start of next function (TS)" },
            ["]c"] = { query = "@class.outer", desc = "start of next class (TS)" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "end of next function (TS)" },
            ["]C"] = { query = "@class.outer", desc = "end of next class (TS)" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "start of previous function (TS)" },
            ["[c"] = { query = "@class.outer", desc = "start of previous class (TS)" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "end of previous function (TS)" },
            ["[C"] = { query = "@class.outer", desc = "end of previous class (TS)" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = {
              query = "@parameter.inner",
              desc = "swap parameters/arguments with next (TS)",
            },
          },
          swap_previous = {
            ["<leader>pa"] = {
              query = "@parameter.inner",
              desc = "swap parameters/arguments with previous (TS)",
            },
          },
        },
      },

      -- Configure Incremental Selection module
      incremental_selection = {
        enable = true,
        keymaps = {
          -- Make sure these keys are available and not mapped elsewhere extensively
          -- `<CR>` (Enter) is often used for node increment/init
          -- `<BS>` (Backspace) is often used for node decrement
          init_selection = "<CR>", -- Start incremental selection easily
          node_incremental = "<CR>", -- Expand selection to larger node using the same key
          -- For scope expansion, you generally need nvim-treesitter/nvim-treesitter-context installed
          -- scope_incremental = '<TAB>', -- Example: Use Tab for scope expansion (requires context plugin)
          node_decremental = "<BS>", -- Shrink selection to smaller node
        },
      },

      -- Add other module configurations if needed
    },

    -- `keys` informs lazy.nvim about keymaps for lazy-loading and discoverability (e.g., which-key).
    -- It mirrors the keys defined in `opts.textobjects.keymaps` but provides metadata.
    -- IMPORTANT: We DO NOT define the `rhs` here; the action is handled by the plugin via `opts`.
    keys = {
      -- == Selection Keymaps (Visual 'v' and Operator-pending 'o' modes) ==
      { "af", mode = { "v", "o" }, desc = "Around Function (TS)" },
      { "if", mode = { "v", "o" }, desc = "Inside Function (TS)" },
      { "ac", mode = { "v", "o" }, desc = "Around Class (TS)" },
      { "ic", mode = { "v", "o" }, desc = "Inside Class (TS)" },
      { "aa", mode = { "v", "o" }, desc = "Around Argument (TS)" },
      { "ia", mode = { "v", "o" }, desc = "Inside Argument (TS)" },

      -- == Movement Keymaps (Normal 'n' mode) ==
      { "]f", mode = "n", desc = "Next Function Start (TS)" },
      { "]c", mode = "n", desc = "Next Class Start (TS)" },
      { "]F", mode = "n", desc = "Next Function End (TS)" },
      { "]C", mode = "n", desc = "Next Class End (TS)" },
      { "[f", mode = "n", desc = "Prev Function Start (TS)" },
      { "[c", mode = "n", desc = "Prev Class Start (TS)" },
      { "[F", mode = "n", desc = "Prev Function End (TS)" },
      { "[C", mode = "n", desc = "Prev Class End (TS)" },

      -- == Swap Keymaps (Normal 'n' mode) ==
      { "<leader>na", mode = "n", desc = "Swap Next Argument (TS)" },
      { "<leader>pa", mode = "n", desc = "Swap Prev Argument (TS)" },

      -- == Incremental Selection Keymaps (Visual Mode 'v' is typical) ==
      -- Although configured in `opts`, adding here helps discoverability if desired,
      -- but they aren't standard mappings lazy.nvim would typically handle/trigger loading.
      -- It's often better to rely on which-key showing the active Visual mode maps if needed.
      -- You *could* add them, but they don't fit the lazy-loading pattern as well.
      -- { '<CR>', mode = 'v', desc = 'Increment Selection (TS)' },
      -- { '<BS>', mode = 'v', desc = 'Decrement Selection (TS)' },
    },
  },

  {
    "saghen/blink.cmp",
    -- In case there are breaking changes and you want to go back to the last
    -- working release
    -- https://github.com/Saghen/blink.cmp/releases
    version = "v1.2.0", -- if anything get fucked, back to v1.1.1
    build = "cargo build --release",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
      "moyiz/blink-emoji.nvim",
      "Kaiser-Yang/blink-cmp-git",
      "echasnovski/mini.icons",
      "giuxtaposition/blink-cmp-copilot",
      {
        "echasnovski/mini.snippets",
        event = "InsertEnter",
        dependencies = {
          "rafamadriz/friendly-snippets",
          { "echasnovski/mini.extra", version = "*" },
        },
        opts = function(_, opts)
          local snippets = require("mini.snippets")
          local config_path = vim.fn.stdpath("config")

          -- NOTE: here is a great source of snippets:
          -- https://github.com/microsoft/vscode/tree/main/extensions
          local custom_snip_dir = config_path .. "/snippets"

          -- Optional: override select popup to prevent virtual text artifacts
          local expand_select_override = function(snips, insert)
            require("blink.cmp").cancel()
            vim.schedule(function()
              snippets.default_select(snips, insert)
            end)
          end

          local snippet_sources = {}

          -- Load global.json first (shared across languages)
          local global_path = custom_snip_dir .. "/global.json"
          if vim.fn.filereadable(global_path) == 1 then
            table.insert(snippet_sources, snippets.gen_loader.from_file(global_path))
          end

          -- Automatically load language-specific snippets like `python.json`
          for _, file in ipairs(vim.fn.readdir(custom_snip_dir)) do
            if file:match("%.json$") and file ~= "global.json" then
              table.insert(
                snippet_sources,
                snippets.gen_loader.from_file(custom_snip_dir .. "/" .. file)
              )
            end
          end

          -- Add built-in mini.extra snippets
          local ok, extra = pcall(require, "mini.extra")
          if ok and extra.gen_snippets then
            table.insert(snippet_sources, extra.gen_snippets(extra.default_snippets))
          end

          -- Final opts
          opts.snippets = snippet_sources
          opts.expand = {
            snippets = { snippets.gen_loader.from_lang() },
            select = function(local_snips, insert)
              local select = expand_select_override or snippets.default_select
              select(local_snips, insert)
            end,
          }
        end,
      },
      { "garymjr/nvim-snippets" }, -- vscode style snippets, has builtin friendly-snippets
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = "*",
      },
    },
    event = "InsertEnter",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    optional = true,
    opts = {
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
      -- Use a preset for snippets, check the snippets documentation for more information
      completion = {
        menu = {
          enabled = true,
          min_width = 15,
          max_height = 10,
          border = "none",
          winblend = 0,
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          -- Keep the cursor X lines away from the top/bottom of the window
          scrolloff = 2,
          -- Note that the gutter will be disabled when border ~= 'none'
          scrollbar = true,
          -- Which directions to show the window,
          -- falling back to the next direction when there's not enough space
          direction_priority = { "s", "n" },

          -- Whether to automatically show the window when new completion items are available
          auto_show = true,

          -- Screen coordinates of the command line
          cmdline_position = function()
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
              return { pos[1] - 1, pos[2] }
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
          draw = {
            align_to = "label", -- or 'none' to disable, or 'cursor' to align to the cursor
            -- Left and right padding, optionally { left, right } for different padding on each side
            padding = 1,
            -- Gap between columns
            gap = 1,
            -- Use treesitter to highlight the label text for the given list of sources
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" }, -- Displays the icon representing the kind of completion
              { "label", "label_description", gap = 1 }, -- Shows the completion text and its description
              { "source_name" }, -- Adds the source name to the menu
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)

                  -- If mini.icons fails, manually return Copilot icon
                  if ctx.kind == "Copilot" then
                    return ""
                  end
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },

              kind = {
                ellipsis = false,
                width = { fill = true },
                text = function(ctx)
                  return ctx.kind
                end,
                highlight = function(ctx)
                  return require("blink.cmp.completion.windows.render.tailwind").get_hl(ctx)
                    or "PmenuKind" .. ctx.kind
                end,
              },

              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  return ctx.label .. ctx.label_detail
                end,
                highlight = function(ctx)
                  -- -- label and label details
                  -- local highlights = {
                  --     { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                  -- }
                  -- if ctx.label_detail then
                  --     table.insert(highlights,
                  --         { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                  -- end
                  --
                  -- -- characters matched on the label by the fuzzy matcher
                  -- for _, idx in ipairs(ctx.label_matched_indices or {}) do
                  --     table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                  -- end
                  --
                  -- return highlights

                  local label_highlights = {}

                  -- Main label: use BlinkCmpKind based on kind
                  table.insert(
                    label_highlights,
                    { 0, #ctx.label, group = "BlinkCmpKind" .. (ctx.kind or "") }
                  )

                  -- Optional label detail part
                  if ctx.label_detail then
                    table.insert(
                      label_highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end

                  -- Fuzzy matched characters
                  for _, idx in ipairs(ctx.label_matched_indices or {}) do
                    table.insert(label_highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end

                  return label_highlights
                end,
              },

              label_description = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.label_description
                end,
                highlight = "BlinkCmpLabelDescription",
              },

              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.source_name
                end,
                highlight = "BlinkCmpSource",
              },
            },
          },
        },
        keyword = {
          range = "prefix", -- fuzzy match on the text before the cursor
        },
        trigger = {
          -- When true, will prefetch the completion items when entering insert mode
          prefetch_on_insert = false,

          -- When false, will not show the completion window automatically when in a snippet
          show_in_snippet = true,

          -- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
          show_on_keyword = true,

          -- When true, will show the completion window after typing a trigger character
          show_on_trigger_character = true,

          -- LSPs can indicate when to show the completion window via trigger characters
          -- however, some LSPs (i.e. tsserver) return characters that would essentially
          -- always show the window. We block these by default.
          show_on_blocked_trigger_characters = function()
            if vim.api.nvim_get_mode().mode == "c" then
              return {}
            end

            -- you can also block per filetype, for example:
            -- if vim.bo.filetype == 'markdown' then
            --   return { ' ', '\n', '\t', '.', '/', '(', '[' }
            -- end

            return { " ", "\n", "\t" }
          end,

          -- When both this and show_on_trigger_character are true, will show the completion window
          -- when the cursor comes after a trigger character after accepting an item
          show_on_accept_on_trigger_character = true,

          -- When both this and show_on_trigger_character are true, will show the completion window
          -- when the cursor comes after a trigger character when entering insert mode
          show_on_insert_on_trigger_character = true,

          -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
          -- the completion window when the cursor comes after a trigger character when
          -- entering insert mode/accepting an item
          show_on_x_blocked_trigger_characters = { "'", "\"", "(" },
          -- or a function, similar to show_on_blocked_trigger_character
        },
        list = {
          -- Maximum number of items to display
          max_items = 200,

          selection = {
            -- When `true`, will automatically select the first item in the completion list
            preselect = false,
            -- preselect = function(ctx) return ctx.mode ~= 'cmdline' end,

            -- When `true`, inserts the completion item automatically when selecting it
            -- You may want to bind a key to the `cancel` command (default <C-e>) when using this option,
            -- which will both undo the selection and hide the completion menu
            auto_insert = false,
            -- auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
          },

          cycle = {
            -- When `true`, calling `select_next` at the *bottom* of the completion list
            -- will select the *first* completion item.
            from_bottom = true,
            -- When `true`, calling `select_prev` at the *top* of the completion list
            -- will select the *last* completion item.
            from_top = true,
          },
        },
        accept = {
          -- Create an undo point when accepting a completion item
          create_undo_point = true,
          -- Experimental auto-brackets support
          auto_brackets = {
            -- Whether to auto-insert brackets for functions
            enabled = true,
            -- Default brackets to use for unknown languages
            default_brackets = { "(", ")" },
            -- Overrides the default blocked filetypes
            override_brackets_for_filetypes = {},
            -- Synchronously use the kind of the item to determine if brackets should be added
            kind_resolution = {
              enabled = true,
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
            },
            -- Asynchronously use semantic token to determine if brackets should be added
            semantic_token_resolution = {
              enabled = true,
              blocked_filetypes = { "java" },
              -- How long to wait for semantic tokens to return before assuming no brackets should be added
              timeout_ms = 400,
            },
          },
        },
        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 200,
          -- Delay before updating the documentation window when selecting a new item,
          -- while an existing item is still visible
          update_delay_ms = 50,
          -- Whether to use treesitter highlighting, disable if you run into performance issues
          treesitter_highlighting = true,
          window = {
            min_width = 10,
            max_width = 80,
            max_height = 20,
            border = "padded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            -- Note that the gutter will be disabled when border ~= 'none'
            scrollbar = true,
            -- Which directions to show the documentation window,
            -- for each of the possible menu window directions,
            -- falling back to the next direction when there's not enough space
            direction_priority = {
              menu_north = { "e", "w", "n", "s" },
              menu_south = { "e", "w", "s", "n" },
            },
          },
        },
        ghost_text = {
          enabled = false,
        },
      },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = {
          "lsp",
          "dadbod",
          "snippets",
          "lazydev",
          "path",
          "buffer",
          "emoji",
          "avante_commands",
          "avante_mentions",
          "avante_files",
          "copilot",
          "git",
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            fallbacks = { "buffer" },
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                  item.score_offset = item.score_offset - 3
                end
              end

              return vim.tbl_filter(function(item)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
              end, items)
            end,
            -- When linking markdown notes, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no LSP
            -- suggestions
            -- Disabling fallbacks as my snippets wouldn't show up
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            -- When typing a path, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no path
            -- suggestions
            fallbacks = { "snippets", "buffer" },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            name = "Buffer",
            module = "blink.cmp.sources.buffer",
            opts = {
              -- default to all visible buffers
              get_bufnrs = function()
                return vim
                  .iter(vim.api.nvim_list_wins())
                  :map(function(win)
                    return vim.api.nvim_win_get_buf(win)
                  end)
                  :filter(function(buf)
                    return vim.bo[buf].buftype ~= "nofile"
                  end)
                  :totable()
              end,
            },
          },
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
          },
          -- https://github.com/moyiz/blink-emoji.nvim
          -- how to trigger: type :
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            opts = { insert = true }, -- Insert emoji (default) or complete its name
          },
          -- ai completion lowest priority
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = -100,
            async = true,
            opts = {
              max_completions = 3,
              ghost_text = false,
            },
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = CompletionItemKind.Copilot or (#CompletionItemKind + 1)

              -- If not assigned, manually set it
              if not CompletionItemKind.Copilot then
                CompletionItemKind[kind_idx] = "Copilot"
                CompletionItemKind["Copilot"] = kind_idx
              end

              for _, item in ipairs(items) do
                item.kind = kind_idx -- Assign the Copilot kind ID
                item.kind_icon = "" -- Explicitly set the Copilot icon
              end

              return items
            end,
          },
          -- cursor like ai
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            opts = {},
          },
          avante_files = {
            name = "avante_commands",
            module = "blink.compat.source",
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            opts = {},
          },
          git = {
            module = "blink-cmp-git",
            name = "Git",
            opts = {
              -- options for the blink-cmp-git
            },
          },
        },

        -- Function to use when transforming the items before they're returned for all providers
        -- The default will lower the score for snippets to sort them lower in the list
        -- transform_items = function(_, items) return items end,

        -- Minimum number of characters in the keyword to trigger all providers
        -- May also be `function(ctx: blink.cmp.Context): number`
        min_keyword_length = 0,
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline" },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          return {}
        end,
        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {},
          },
          list = {
            selection = {
              -- When `true`, will automatically select the first item in the completion list
              preselect = true,
              -- When `true`, inserts the completion item automatically when selecting it
              auto_insert = true,
            },
          },
          menu = {
            auto_show = true,
            -- draw = {
            --     columns = { { 'label', 'label_description', gap = 1 } },
            -- },
          },
          ghost_text = { enabled = false },
        },
      },
      appearance = {
        -- highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        -- use_nvim_cmp_as_default = false,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        -- nerd_font_variant = 'mono',

        kind_icons = blink_kind_icons_set_one,
      },
    },
    config = function(_, opts)
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      -- use customized highlight groups
      for group, hl in pairs(completion_menu_highlight_groups) do
        vim.api.nvim_set_hl(0, group, hl)
      end

      -- print(vim.inspect(opts))
      require("blink.cmp").setup(opts)
    end,
  },

  { -- nvim-lspconfig is deprecated...

    {
      "mfussenegger/nvim-dap-python",
      dependencies = { "jay-babu/mason-nvim-dap.nvim", "mfussenegger/nvim-dap" },
    },
    { "leoluz/nvim-dap-go" },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } }, -- Luv support for Lua files
        },
      },
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        {
          "williamboman/mason.nvim",
          init = function()
            require("mason").setup()
          end,
          keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "mason" },
          },
        },
      },

      opts = {
        ensure_installed = {
          "lua_ls",
          "pyright",
          "clangd",
          "gopls",
          "golangci_lint_ls",
          "jdtls",
          "zls",
          "tailwindcss",
          "harper_ls",
          "marksman",
        },
        automatic_enable = true,
      },
      config = function(_, opts)
        require("mason-lspconfig").setup(opts)

        -- overwrite customized lsp
        -- lua-ls
        vim.lsp.config["lua_ls"] = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT", -- LuaJIT is used by Neovim
              },
              diagnostics = {
                -- Specifies global variables (like vim and use) to prevent false-positive warnings about undefined globals.
                globals = { "vim", "use" }, -- 'use' for packer
              },
              workspace = {
                --  Informs the server about additional directories to include in the workspace, such as Neovim's runtime files and your custom Lua configuration.
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              completion = {
                callSnippet = "Both",
                keywordSnippet = "Both",
              },
            },
          },
        }
        vim.lsp.enable("luals")

        -- Configure diagnostics to show virtual text
        -- Use virtual text as usual
        vim.diagnostic.config({
          virtual_text = {
            spacing = 2,
            prefix = "●",
          },
          float = {
            border = "rounded",
            source = "if_many",
            header = "Diagnostics",
            focusable = false,
          },
          update_in_insert = false,
          severity_sort = true,
        })

        -- Show float manually with tree-style formatting on CursorHold
        vim.o.updatetime = 250
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          callback = function()
            local optss = {
              focusable = false,
              border = "rounded",
              source = "if_many",
              header = "Diagnostics",
              format = function(diagnostic)
                local message = diagnostic.message:gsub("\n", " ")
                local source = diagnostic.source or "n/a"
                local severity = vim.diagnostic.severity[diagnostic.severity] or "Unknown"
                return string.format(
                  "├─ %s\n│   ↪ Source: %s\n│   ↪ Severity: %s",
                  message,
                  source,
                  severity
                )
              end,
            }
            vim.diagnostic.open_float(nil, optss)
          end,
        })
      end,
    },
    vim.keymap.set("n", "gK", function()
      local new_config = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = new_config })
    end, { desc = "Toggle diagnostic virtual_lines" }),
  },

  -- autopair
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
    end,
  },

  -- todos,notes,etc in comments highlight
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      signs = false,
    },
  },

  -- ts comments
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    },
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },

  -- variable rename
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup({})
      vim.keymap.set("n", "<leader>rn", ":IncRename")
    end,
  },

  {
    -- python venv selector
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
      {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    lazy = false,
    config = function()
      require("venv-selector").setup({
        debug = true, -- enables you to run the VenvSelectLog command to view debug logs
      })
    end,
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
    },
  },

  -- cpp man from cplusplus.com and cppreference.com without ever leaving neovim
  {
    "madskjeldgaard/cppman.nvim",
    dependencies = {
      { "MunifTanjim/nui.nvim" },
    },
    config = function()
      local cppman = require("cppman")
      cppman.setup()

      -- -- Make a keymap to open the word under cursor in CPPman
      -- vim.keymap.set("n", "<leader>cp", function()
      --   cppman.open_cppman_for(vim.fn.expand("<cword>"))
      -- end)
      --
      -- -- Open search box
      vim.keymap.set("n", "<leader>cc", function()
        cppman.input()
      end, { desc = "open cpp search" })
      vim.keymap.set(
        "n",
        "<leader>cp",
        "<cmd>lua require('cppman').open_cppman_for(vim.fn.expand('<cword>'))<cr>",
        { desc = "Open cppman for word under cursor" }
      )
    end,
  },
  -- clang
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    opts = clangd_ext_opts,
  },

  -- rust
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = "rust",
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          -- rustaceanvim fallbacks to $PATH
          -- NOTE: you have to install rust-analyzer yourself using cargo
          -- cmd = { "rust-analyzer" }, -- Use global binary (installed via rustup)
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>ra", function()
              vim.cmd.RustLsp("codeAction")
            end, { buffer = bufnr })
          end,
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              inlayHints = {
                chainingHints = true,
                parameterHints = true,
                typeHints = true,
              },
            },
          },
        },
      }
    end,
  },

  -- inlay hints
  {
    "folke/snacks.nvim",
    opts = {
      inlay_hints = {
        enabled = true, -- Enable inlay hints globally
        debounce = 200, -- Debounce updates for performance
        display = {
          highlight = "Comment", -- Color customization
          virtual_text = true, -- Show as virtual text
          priority = 100, -- Set hint priority
        },
        exclude = { "markdown", "text" }, -- Exclude unwanted filetypes
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      vim.keymap.set("n", "<leader>si", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle Inlay Hints" })
    end,
  },
}
