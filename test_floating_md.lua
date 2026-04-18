local lines = { "```lua", "function test()", "end", "```" }
local bufnr, winnr = vim.lsp.util.open_floating_preview(lines, "markdown", {})
print("Lines in floating buf:", vim.inspect(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)))
