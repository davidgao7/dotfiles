local bufnr = vim.api.nvim_create_buf(false, true)
local lines = { "```lua", "function test()", "end", "```" }
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
vim.lsp.util.stylize_markdown(bufnr, lines)
print("Filetype:", vim.bo[bufnr].filetype)
print("Syntax:", vim.bo[bufnr].syntax)
print("Lines:", vim.inspect(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)))
