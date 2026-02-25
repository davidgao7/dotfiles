return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").add({ "<C-g>s", mode = "i", desc = "add surround" })
      require("which-key").add({ "<C-g>S", mode = "i", desc = "add surround line" })
      require("which-key").add({ "ys", mode = "n", desc = "add surround+motion" })
      require("which-key").add({ "yss", mode = "n", desc = "add surround line+motion" })
      require("which-key").add({ "cs", mode = "n", desc = "change surround+motion" })
      require("which-key").add({ "cS", mode = "n", desc = "change line surround+motion" })
      require("which-key").add({ "ds", mode = "n", desc = "Delete a surrounding pair" })
      require("which-key").add({ "S", mode = "v", desc = "Surround visual selection" })
      require("which-key").add({ "gS", mode = "v", desc = "Surround visual line" })
      require("which-key").add({ "yT", mode = "v", desc = "Surround new line" })
      require("which-key").add({ "ySS", mode = "n", desc = "Surround line" })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      -- 1. Disable all default v4 mappings so they don't conflict with yours
      vim.g.nvim_surround_no_insert_mappings = true
      vim.g.nvim_surround_no_normal_mappings = true
      vim.g.nvim_surround_no_visual_mappings = true

      -- 2. Setup with your non-keymap options
      require("nvim-surround").setup({
        highlight = {
          duration = 0, -- Matching your existing config
        },
      })

      -- 3. Define the exact mappings from your previous config
      local set = vim.keymap.set

      -- Normal Mode
      set("n", "ys", "<Plug>(nvim-surround-normal)", { desc = "Add surrounding pair" })
      set("n", "yss", "<Plug>(nvim-surround-normal-cur)", { desc = "Add surrounding pair (line)" })
      set(
        "n",
        "yT",
        "<Plug>(nvim-surround-normal-line)",
        { desc = "Add surrounding pair (new line)" }
      )
      set(
        "n",
        "ySS",
        "<Plug>(nvim-surround-normal-cur-line)",
        { desc = "Add surrounding pair (cur line new line)" }
      )
      set("n", "ds", "<Plug>(nvim-surround-delete)", { desc = "Delete surrounding pair" })
      set("n", "cs", "<Plug>(nvim-surround-change)", { desc = "Change surrounding pair" })
      set(
        "n",
        "cS",
        "<Plug>(nvim-surround-change-line)",
        { desc = "Change surrounding pair (line)" }
      )

      -- Visual Mode (using 'x' for visual mode)
      set("x", "S", "<Plug>(nvim-surround-visual)", { desc = "Surround selection" })
      set("x", "gS", "<Plug>(nvim-surround-visual-line)", { desc = "Surround selection (line)" })

      -- Insert Mode
      set("i", "<C-g>s", "<Plug>(nvim-surround-insert)", { desc = "Insert surrounding pair" })
      set(
        "i",
        "<C-g>S",
        "<Plug>(nvim-surround-insert-line)",
        { desc = "Insert surrounding pair (line)" }
      )
    end,
  },
}
