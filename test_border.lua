local bufnr = vim.api.nvim_create_buf(false, true)
local ui = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, title = " ฅ^•ﻌ•^ฅ " }
local win = vim.api.nvim_open_win(bufnr, false, {relative="cursor", row=1, col=1, width=10, height=10, border=ui.border, title=ui.title})
print("Win created:", win)
