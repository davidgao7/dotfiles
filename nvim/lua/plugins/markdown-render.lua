return {
  {
    -- Make sure to set this up properly if you have lazy=true
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      filetypes = { "markdown", "Avante" },
      -- in-process lsp completion
      completions = {
        blink = {
          enabled = true,
        },
      },
      code = {
        enabled = true,
        -- highlight for code blocks
        highlight = "RenderMarkdownCode",
        left_pad = 1,
        right_pad = 1,
        border = "rounded",
        -- Determines how code blocks & inline code are rendered.
        -- | none     | disables all rendering                                                    |
        -- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
        -- | language | language icon to sign column if enabled and icon + name above code blocks |
        -- | full     | normal + language
        style = "full",
        -- Determines where language icon is rendered.
        -- | right | right side of code block |
        -- | left  | left side of code block  |
        position = "left",
        -- Whether to include the language name above code blocks.
        language_name = true,
        -- A list of language names for which background highlighting will be disabled.
        -- Likely because that language has background highlights itself.
        -- Use a boolean to make behavior apply to all languages.
        -- Borders above & below blocks will continue to be rendered.
        disable_background = { "diff" },
      },
      overrides = {
        buftype = {
          nofile = {
            enabled = false, -- ❗ Disable in hover float (e.g., LSP)
          },
        },
      },
    },
    ft = { "markdown", "Avante" },
  },
}
