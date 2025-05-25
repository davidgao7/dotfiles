return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        registers = true,
      },
      show_missing = true, -- show keys without descriptions
    },
  },
}
