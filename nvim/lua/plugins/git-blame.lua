return {
  {
    -- git blame plugin
    -- "f-person/git-blame.nvim",
    -- dir = "~/Downloads/git-blame.nvim",
    "davidgao7/git-blame.nvim",
    branch = "blame-floating-window",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      enabled = true,
      message_template = " <author> • <date> • <summary> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
    },
    keys = {
      {
        "<leader>gbu",
        "<cmd>GitBlameToggle<cr>",
        desc = "toggle git blame",
      },
      {
        "<leader>gbe",
        "<cmd>GitBlameEnable<cr>",
        desc = "enable git blame",
      },
      {
        "<leader>gbd",
        "<cmd>GitBlameDisable<cr>",
        desc = "disable git blame",
      },
      {
        "<leader>gbh",
        "<cmd>GitBlameCopySHA<cr>",
        desc = "copy line commit SHA",
      },
      {
        "<leader>gbl",
        "<cmd>GitBlameCopyCommitURL<cr>",
        desc = "copy line commit URL",
      },
      {
        "<leader>gbo",
        "<cmd>GitBlameOpenFileURL<cr>",
        desc = "opens file in default browser",
      },
      {
        "<leader>gbc",
        "<cmd>GitBlameCopyFileURL<cr>",
        desc = "copy file url to clipboard",
      },
      {
        "<leader>gbt",
        "<cmd>GitBlameToggleCommitMesgWindow<cr>",
        desc = "show git blame in floating window",
      },
    },
  },
  {
    "folke/which-key.nvim",
    -- default show git blame when open git files
    opts = {
      defaults = {
        ["<leader>gb"] = { name = "git blame+" },
      },
    },
  },
}
-- enable git blame if git file
-- enableGitBlameIfGitFile()
