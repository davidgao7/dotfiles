local obsidian_dir = "/Users/tengjungao/Downloads/obsidian-vault"

return {
  -- Obsidian.nvim plugin
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- Use the latest release
    lazy = true,
    ft = "markdown",
    dependencies = {
      -- Required dependency
      "nvim-lua/plenary.nvim",
      -- Optional dependencies for enhanced functionality
      "nvim-treesitter/nvim-treesitter", -- Syntax highlighting
      "saghen/blink.cmp", -- Completion
      "ibhagwan/fzf-lua", -- picker
      "folke/snacks.nvim", -- image viewing
    },
    opts = {
      legacy_commands = false, -- The legacy format of commands will no longer be maintained from version 4.0.0.
      -- Define your Obsidian vaults
      workspaces = {
        {
          name = "notes",
          path = obsidian_dir,
        },
        -- Add more workspaces if needed
      },
      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = false,
      frontmatter = {
        func = function(note)
          local hugo_dir = string.format("%s/davidgao7blogs", obsidian_dir)
          local current_file = vim.fn.expand("%:p")
          if current_file:sub(1, #hugo_dir) == hugo_dir then
            -- If the file is in the Hugo directory, return an empty table to disable front matter
            return {}
          else
            -- Default front matter for other files
            return {
              id = note.id,
              aliases = note.aliases,
              tags = note.tags,
              -- Add other default front matter fields as needed
            }
          end
        end,
      },
      -- Set the log level for obsidian.nvim
      log_level = vim.log.levels.INFO,
      -- Configuration for daily notes
      daily_notes = {
        folder = "notes/dailies",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "daily_template.md", -- Specify your daily note template
        workdays_only = false, -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
      },
      -- User interface settings
      ui = {
        enable = false, -- Set to true to enable Obsidian's UI features
      },
      -- Completion settings
      completion = {
        -- Enables completion using nvim_cmp
        nvim_cmp = false,
        -- Enables completion using blink.cmp
        blink = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
        -- Set to false to disable new note creation in the picker
        create_new = true,
      },

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
        name = "fzf-lua",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      -- Where to put new notes. Valid options are
      -- _ "current_dir" - put new notes in same directory as the current buffer.
      -- _ "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      -- Function to generate note IDs
      note_id_func = function(title)
        -- local suffix = ""
        -- if title ~= nil then
        --     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        -- else
        --     for _ = 1, 4 do
        --         suffix = suffix .. string.char(math.random(65, 90))
        --     end
        -- end
        -- return tostring(os.time()) .. "-" .. suffix
        local uuid = vim.fn.system("uuidgen"):gsub("%-%s", ""):lower():gsub("%\n", "")
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        end
        return uuid .. "-" .. suffix
      end,
      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
      -- Template settings
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function.
        -- Functions are called with obsidian.TemplateContext objects as their sole parameter.
        -- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
        substitutions = {},

        -- A map for configuring unique directories and paths for specific templates
        --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations
        customizations = {},
      },
    },

    -- create new key mappings
    -- [[
    -- mappings = {
    --   ["gd"] = { -- lets always to go to definition
    --     action = function()
    --       return require("obsidian").util.gf_passthrough()
    --     end,
    --     opts = { noremap = false, expr = true, buffer = true },
    --   },
    --   ["<leader>ch"] = {
    --     action = function()
    --       return require("obsidian").util.toggle_checkbox()
    --     end,
    --     opts = { buffer = true },
    --   },
    --   ["<cr>"] = {
    --     action = function()
    --       return require("obsidian").util.smart_action()
    --     end,
    --     opts = { buffer = true, expr = true },
    --   },
    -- },]]
  },
}
