-- Custom Copilot Status Component
local function copilot_status()
  local ok, clients = pcall(vim.lsp.get_clients)
  if not ok or not clients then
    return ""
  end
  for _, client in ipairs(clients) do
    if client.name == "copilot" then
      return ""
    end
  end
  return ""
end

-- statusline recording indicator
local function recording_status()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  else
    return "@" .. reg
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Eviline config for lualine
      -- Author: shadmansaleh
      -- Credit: glepnir
      local lualine = require("lualine")

            -- Color table for highlights
            -- stylua: ignore
            local colors = {
                bg       = '#202328',
                fg       = '#bbc2cf',
                yellow   = '#ECBE7B',
                cyan     = '#008080',
                darkblue = '#081633',
                green    = '#98be65',
                orange   = '#FF8800',
                violet   = '#a9a1e1',
                magenta  = '#c678dd',
                blue     = '#51afef',
                red      = '#ec5f67',
            }

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      -- Config
      local config = {
        options = {
          -- Disable sections and component separators
          component_separators = "",
          section_separators = "",
          theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
          },
        },
        sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          -- These will be filled later
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      -- Inserts a component in lualine_x at right section
      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      -- ins_left {
      --     function()
      --         return '▊'
      --     end,
      --     color = { fg = colors.blue },      -- Sets highlighting of component
      --     padding = { left = 0, right = 1 }, -- We don't need space before this
      -- }

      ins_left({
        -- mode component
        function()
          return ""
        end,
        color = function()
          -- auto change color according to neovims mode
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
      })

      ins_left({
        function()
          local mode_map = {
            n = "NORM",
            i = "INSRT",
            v = "VISUAL",
            V = "V-LINE",
            [""] = "V-BLK", -- visual block mode
            c = "CMD  ",
            R = "REPL ",
            t = "TERM ",
          }
          local mode = vim.fn.mode()
          return mode_map[mode] or mode
        end,
        color = function()
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            V = colors.blue,
            [""] = colors.blue,
            c = colors.magenta,
            R = colors.violet,
            t = colors.orange,
          }
          return { fg = mode_color[vim.fn.mode()] or colors.cyan, gui = "bold" }
        end,
        padding = { right = 1 },
      })

      ins_left({
        -- filesize component
        "filesize",
        cond = conditions.buffer_not_empty,
      })

      -- ins_left {
      --     'filename',
      --     cond = conditions.buffer_not_empty,
      --     color = { fg = colors.magenta, gui = 'bold' },
      -- }

      ins_left({
        "diff",
        -- Is it me or the symbol for modified us really weird
        symbols = { added = " ", modified = "󰝤 ", removed = " " },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      })

      ins_left({ "location" })

      ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

      ins_left({
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          info = { fg = colors.cyan },
        },
      })

      ins_left({
        copilot_status, -- Add Copilot status function here
      })

      ins_left({
        recording_status, -- Add recording status function here
      })

      -- Insert mid section. You can make any number of sections in neovim :)
      -- for lualine it's any number greater then 2
      ins_left({
        function()
          return "%="
        end,
      })

      ins_left({
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return " No Active LSP"
          end
          return " LSP (" .. #clients .. ")"
        end,
        on_click = function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            vim.notify("No active LSPs", vim.log.levels.INFO, { title = "LSP Info" })
            return
          end

          local lines = {}
          for _, client in ipairs(clients) do
            table.insert(lines, "• " .. client.name)
          end
          vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
            title = "Active LSPs",
            timeout = 3000,
          })
        end,
        color = { fg = "#ffffff", gui = "bold" },
      })
      -- Add components to right sections

      ins_right({
        "o:encoding", -- option component same as &encoding in viml
        fmt = string.upper, -- I'm not sure why it's upper case either ;)
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = "bold" },
      })

      ins_right({
        "fileformat",
        fmt = string.upper,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.green, gui = "bold" },
      })

      ins_right({
        "branch",
        icon = "",
        color = { fg = colors.violet, gui = "bold" },
      })

      -- ins_right {
      --     'diff',
      --     -- Is it me or the symbol for modified us really weird
      --     symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
      --     diff_color = {
      --         added = { fg = colors.green },
      --         modified = { fg = colors.orange },
      --         removed = { fg = colors.red },
      --     },
      --     cond = conditions.hide_in_width,
      -- }

      ins_right({
        function()
          return "▊"
        end,
        color = { fg = colors.blue },
        padding = { left = 1 },
      })

      -- Now don't forget to initialize lualine
      lualine.setup(config)
    end,
  },
}
