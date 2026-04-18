local ui = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, title = "title" }
local b, w = vim.lsp.util.open_floating_preview({"test"}, "markdown", ui)
print("Config:", vim.inspect(vim.api.nvim_win_get_config(w)))
