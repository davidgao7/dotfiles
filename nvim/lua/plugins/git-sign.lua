return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      sign_priority = 20, -- keeps it above LSP (10) but below urgent alerts
      status_formatter = nil, -- This makes the column look cleaner
      word_diff = false, -- This makes the column look cleaner
      auto_attach = true,
      current_line_blame = false,
      max_file_length = 40000, -- disable if file is longer than this (in lines)
    },
  },
}
