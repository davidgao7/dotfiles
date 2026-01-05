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
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
          documentation = {
            -- 💡 FORCE this to use your hover view
            view = "hover",
            opts = {
              border = {
                style = "rounded",
              },
              win_options = {
                winblend = 0,
                winhighlight = {
                  Normal = "NormalFloat",
                  FloatBorder = "LspHoverBorder",
                },
              },
            },
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
        views = {
          hover = {
            border = {
              style = "rounded", -- Options: "single", "double", "rounded", "solid"
            },
            position = { row = 2, col = 2 },
            win_options = {
              winblend = 0, -- Ensure transparency is disabled
              winhighlight = {
                -- This links the internal FloatBorder group to your custom Peach color
                FloatBorder = "LspHoverBorder",
                -- Optional: Link Normal background to your solid background group
                Normal = "NormalFloat",
              },
            },
          },
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
