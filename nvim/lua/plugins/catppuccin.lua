return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    dependencies = {
      "rcarriga/nvim-notify",
    },
    -- you can do it like this with a config function
    config = function()
      require("catppuccin").setup({
        -- configurations
        flavour = "auto", -- latte, frappe, macchiato, mocha, auto(mocha for dark vim.o.background, latte for light vim.o.background)
        -- background = { -- :h background
        -- 	light = "latte",
        -- 	dark = "mocha",
        -- },
        transparent_background = true, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = { "italic" },
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",
          },
        },
        custom_highlights = function(colors)
          return {
            -- Float windows
            NormalFloat = { fg = colors.text, bg = "#1e1e2e" },
            FloatBorder = { fg = colors.surface2, bg = "#1e1e2e" },
            -- LspInfoBorder = { fg = colors.blue, bg = "#1e1e2e" },

            -- to include the background color
            LspHoverBorder = { fg = colors.peach, bg = "#1e1e2e", bold = true },

            -- Ensure Noice's specific popup groups are also solid
            NoicePopup = { bg = "#1e1e2e" },
            NoicePopupBorder = { fg = colors.surface2, bg = "#1e1e2e" },

            LspInfoTitle = { fg = colors.pink, bg = "#1e1e2e", bold = true },
            LspFloatWinNormal = { fg = colors.text, bg = "#1e1e2e" },

            -- Markdown legacy
            markdownCode = { fg = colors.teal, bg = "#1e1e2e" },
            markdownCodeBlock = { fg = colors.teal, bg = "#1e1e2e" },
            markdownBold = { fg = colors.yellow, bold = true },
            markdownItalic = { fg = colors.pink, italic = true },
            markdownH1 = { fg = colors.red, bold = true },
            markdownH2 = { fg = colors.green, bold = true },
            markdownLinkText = { fg = colors.blue, underline = true },

            -- Treesitter markdown
            ["@markup.raw.block"] = { fg = colors.teal, bg = "#1e1e2e" },
            ["@markup.raw.inline"] = { fg = colors.teal, bg = "#1e1e2e" },
            ["@markup.raw.block.markdown"] = { fg = colors.teal, bg = "#1e1e2e" },
            ["@markup.raw.inline.markdown"] = { fg = colors.teal, bg = "#1e1e2e" },
            ["@markup.strong"] = { fg = colors.yellow, bold = true },
            ["@markup.italic"] = { fg = colors.pink, italic = true },
            ["@markup.link.label"] = { fg = colors.blue, underline = true },
            ["@markup.link.url"] = { fg = colors.teal, underline = true },
          }
        end,
        default_integrations = true,
        integrations = {
          blink_cmp = {
            style = "bordered",
          },
          gitsigns = true,
          nvimtree = true,
          neotree = true,
          treesitter = true,
          notify = false,
          hop = true,
          mason = true,
          which_key = true,
          dashboard = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          dap = {
            enabled = true,
            enable_ui = true,
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })
      -- enable one of the catppuccin colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
    -- or just use opts table
    -- opts = {
    --   -- configurations
    -- },
  },
}
