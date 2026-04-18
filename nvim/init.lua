-- Ensure Homebrew binaries are in the path for Tree-sitter compilation
vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH

require("config.lazy")
