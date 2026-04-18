local neko_ui = {
  border = {
    "╭", "─", "╮", "│", "╯", "─", "╰", "│",
  },
  title = " ฅ^•ﻌ•^ฅ ",
  title_pos = "center",
  winhighlight = "FloatBorder:LspHoverBorder,Normal:NormalFloat,EndOfBuffer:NormalFloat",
}

local lines = { "```lua", "function test()", "end", "```" }
local bufnr, winnr = vim.lsp.util.open_floating_preview(lines, "markdown", neko_ui)
print("Bufnr:", bufnr, "Winnr:", winnr)
if winnr then
  local conf = vim.api.nvim_win_get_config(winnr)
  print("Border config:", vim.inspect(conf.border))
  print("Winhighlight:", vim.inspect(vim.wo[winnr].winhighlight))
end
