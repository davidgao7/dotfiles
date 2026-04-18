return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      background_colour = "#1e1e2e", -- Match your Catppuccin theme
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      stages = "fade_in_slide_out",
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        routes = {
          {
            filter = {
              event = "notify",
              find = "No information available",
            },
            opts = { skip = true },
          },
        },
        lsp = {
          -- Completely disable Noice for hover and signature to let Neko UI win
          hover = { enabled = false },
          signature = { enabled = false },
          -- Also disable the documentation view just in case
          documentation = { enabled = false },
          -- Use default Neovim markdown formatting
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          -- lsp_doc_border = true, -- DISABLED: This was hijacking the border!
        },
        views = {
          -- DISABLED: Let global vim.lsp.handlers take control
          -- hover = {
          --   border = {
          --     style = "rounded",
          --   },
          --   position = { row = 2, col = 2 },
          --   win_options = {
          --     winblend = 0,
          --     winhighlight = {
          --       FloatBorder = "LspHoverBorder",
          --       Normal = "NormalFloat",
          --     },
          --   },
          -- },
          history = {
            backend = "fzf_lua",
          },
        },
      })

      vim.keymap.set(
        "n",
        "<leader>sh",
        "<cmd>Noice history<cr>",
        { desc = "Show notification history" }
      )
    end,
  },
}
