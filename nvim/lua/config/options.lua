-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.disable_autoformat = false

-- setup mason python verson to use
vim.g.python3_host_prog = os.getenv("HOME")
  .. "/.pyenv/versions/neovim_default_python_env/bin/python"

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- show relative line numbers
vim.opt.relativenumber = true
-- set cursor gui to be block always
-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"
-- hightlight current line
vim.opt.cursorline = true
-- show the file path in the title
vim.opt.winbar = "%=%m %f"
-- always toggle off the conceallevel and always show everything
vim.opt.conceallevel = 0
-- set vertical refernce line
vim.opt.colorcolumn = "90"
-- enable mouse mode
vim.opt.mouse = "a"

-- indent blankline configuration
vim.opt.list = true

-- enable mouse mode
vim.opt.mouse = "a"

-- smart indent
vim.opt.smartindent = true

-- grep case-insensitive
vim.opt.grepprg = "rg --vimgrep --smart-case"
-- Ignore case in searches
vim.o.ignorecase = true
-- Override ignorecase if the search includes uppercase letters
vim.o.smartcase = true
-- ensures that suggestions are displayed, but none are preselected or auto-inserted,
-- allowing you to manually select the desired completion
vim.o.completeopt = "menu,menuone,noinsert,noselect"

-- sync with system clipboard
-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- show invisible characters
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.*", -- Apply to all buffers
  desc = "Show invisible characters",
  callback = function()
    vim.wo.list = true
    vim.wo.listchars = "tab:▸ ,trail:·,extends:❯,precedes:❮,nbsp:·,eol:¬"
  end,
})

-- highlight when yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- add react filetype
vim.filetype.add({
  extension = {
    jsx = "javascriptreact",
    tsx = "typescriptreact",
  },
})

-- use lsp built-in highlighting
vim.o.updatetime = 200 -- optimize delay for CursorHold

-- local function should_render_cursor_hl()
--     local excluded_filetypes = {
--         -- list all file type which you don't want cursor hl
--         "markdown",
--         "oil",
--         "html"
--     }
--     local res = not vim.tbl_contains(excluded_filetypes, vim.bo.filetype)
--     return res
-- end

-- highlight variables under cursor
--[[
--When the cursor is held in place, the autocommand checks all active LSP clients attached
--to the current buffer to see if any of them support the documentHighlight method.
--If at least one does, it calls vim.lsp.buf.document_highlight().
--]]
--
---- Create the group first to avoid the "Invalid 'group'" error
local LspDocumentHighlightGroup =
  vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = LspDocumentHighlightGroup,
  pattern = "*",
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentHighlightProvider then
        vim.lsp.buf.document_highlight()
        return
      end
    end
  end,
})

-- [[
-- When the cursor moves, it clears any highlighted references
-- ]]
vim.api.nvim_create_autocmd("CursorMoved", {
  group = LspDocumentHighlightGroup,
  pattern = "*",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- Auto-refresh fzf-lua ignore file cache when known ignore files are saved
vim.api.nvim_create_autocmd("BufWritePost", {
  -- Trigger this autocmd when any of these ignore-related files are written
  pattern = { ".ignore", ".gitignore", ".rgignore", ".fdignore" },
  callback = function(args)
    -- Extract just the filename from the full file path
    local changed_file = vim.fn.fnamemodify(args.file, ":t")

    -- Defer execution slightly to ensure file system is updated
    vim.defer_fn(function()
      -- Only proceed if fzf-lua is loaded and the cache table exists
      if package.loaded["fzf-lua"] and _G.fzf_cache then
        -- Attempt to require your fzf-lua config module to access its functions
        -- ⚠️ Adjust the module path below based on where your `fzf.lua` lives in your setup
        local ok, fzf_lua_mod = pcall(require, "plugins.fzf")

        -- If the module loaded and it exposes get_existing_ignore_files, reload the cache
        if ok and fzf_lua_mod and type(fzf_lua_mod.get_existing_ignore_files) == "function" then
          _G.fzf_cache.ignore_opts_cache = fzf_lua_mod.get_existing_ignore_files()
        else
          -- If something fails, fall back to clearing the cache
          _G.fzf_cache.ignore_opts_cache = nil
        end

        -- Notify the user that the cache has been refreshed
        vim.notify("fzf-lua ignore cache reloaded due to: " .. changed_file, vim.log.levels.INFO)
      end
    end, 100) -- Delay slightly (100ms) to avoid race conditions
  end,
})

-- [[ INDENTATION CONFIGURATION ]]

-- set size of an indent to 4 spaces
vim.opt.shiftwidth = 4
-- pressing tab key will insert 4 spaces
vim.opt.expandtab = true
-- number of spaces inserted instead of a tab
vim.opt.softtabstop = 4
-- a tab is 4 spaces
vim.opt.tabstop = 4

-- Separate indentation guide for key value style files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "yaml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.smartindent = false
    vim.opt_local.autoindent = true
  end,
})

-- Separate indentation guide for lua, for lua I like 2 space indent
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
})

-- python indentation guide(yea, tab)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
})
