-- Wrap in a module-like table
local fzf_cache = {
    ignore_opts_cache = nil
}

-- Expose it globally for other files (like options.lua) to use
_G.fzf_cache = fzf_cache

local function get_neotree_root()
    -- Lazily load Neo-tree if not already loaded
    require("lazy").load({ plugins = { "neo-tree.nvim" } })

    -- Safe require (avoids crashing if loading failed)
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if not ok then return vim.fn.getcwd() end

    local state = manager.get_state("filesystem")
    return state and state.path or vim.fn.getcwd()
end


local function get_existing_ignore_files()
    local root = get_neotree_root()
    local ignore_files = { ".ignore", ".gitignore", ".rgignore", ".fdignore" }
    local existing = {}

    for _, filename in ipairs(ignore_files) do
        local fullpath = root .. "/" .. filename
        if vim.fn.filereadable(fullpath) == 1 then
            table.insert(existing, "--ignore-file")
            table.insert(existing, fullpath)
        end
    end

    return existing
end

local function universal_previewer(filepath)
    local ext = vim.fn.fnamemodify(filepath, ":e"):lower()

    if ext == "png" or ext == "jpg" or ext == "jpeg" or ext == "gif" or ext == "bmp" then
        return { "chafa", "-c", "full", "-f", "sixel", filepath }
    elseif ext == "pdf" then
        return { "pdftotext", filepath, "-" }
    else
        return { "bat", "--style=numbers", "--color=always", "--wrap=character", filepath }
    end
end

-- Manually clear the cached ignore file list (useful if something feels off)
vim.api.nvim_create_user_command("FzfIgnoreCacheClear", function()
    _G.fzf_cache.ignore_opts_cache = nil
    vim.notify("fzf-lua ignore cache manually cleared", vim.log.levels.INFO)
end, { desc = "Clear fzf-lua ignore file cache" })

-- Force a reload of all known ignore files into cache
vim.api.nvim_create_user_command("FzfReloadIgnore", function()
    _G.fzf_cache.ignore_opts_cache = get_existing_ignore_files()
    vim.notify("fzf-lua ignore cache reloaded manually", vim.log.levels.INFO)
end, { desc = "Manually reload ignore files into fzf-lua cache" })

-- caching the ignore files per session for better performace
local function get_cached_ignore_files()
    if not fzf_cache.ignore_opts_cache then
        fzf_cache.ignore_opts_cache = get_existing_ignore_files()
    end
    return fzf_cache.ignore_opts_cache
end

return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons",
            "nvim-neo-tree/neo-tree.nvim", -- optional: enforce load order
        },
        config = function()
            -- calling `setup` is optional for customization
            require("fzf-lua").setup({
                -- debug = true,
                -- default configuration options
                winopts = {
                    -- relative portions of the terminal window
                    height = 0.85, -- Window takes up 85% of terminal height
                    width = 0.85,
                    border = "rounded",
                    -- fullscreen = false, -- ensure floating window

                    preview = {
                        -- default = "bat",
                        -- hidden = false,     -- always show preview window
                        layout = "flex",    -- auto adjust layout based on space
                        flip_columns = 120, -- adjust layout when terminal width < 120 columns
                        scrollbar = true,   -- show a scrollbar
                        title = true,
                        delay = 100,
                        -- configure the builtin previewer to use the custom function
                        builtin = {
                            title = true,
                            scrollbar = true,
                            delay = 100,
                            -- define the custom previewer function
                            fn = function(filepath, bufnr, opts)
                                local preview_cmd = universal_previewer(filepath)
                                if preview_cmd then
                                    -- convert the command table into a string
                                    local cmd_str = table.concat(preview_cmd, " ")
                                    require("fzf-lua.previewer").cmd_sync(cmd_str, bufnr, opts)
                                else
                                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false,
                                        { "No preview available for this file type." })
                                end
                            end,
                        },
                    },
                },
                grep = {
                    rg_cmd = "rg", -- ✅ ensure it uses system rg, not relative path
                    rg_opts = function()
                        local base_opts = {
                            "--hidden",
                            "--column",
                            "--line-number", -- Needed or fzf-lua warns
                            "--no-heading",
                            "--color=always",
                            "--smart-case",
                            "--glob", "!.git/",
                            "--glob", "!*.lock",
                        }

                        local ignore_opts = get_cached_ignore_files()
                        return table.concat(vim.iter({ base_opts, ignore_opts }):flatten():totable(), " ")
                    end,
                    cwd = get_neotree_root,
                    prompt = "Rg Live Grep> ",
                    input_prompt = "Grep for >",
                    silent = true,
                    actions = {
                        ["default"] = require("fzf-lua.actions").file_edit,
                    },
                },
                live_grep = {
                    rg_cmd = "rg", -- ✅ ensure it uses system rg, not relative path
                    rg_opts = function()
                        local base_opts = {
                            "--hidden",
                            "--column",
                            "--line-number", -- Needed or fzf-lua warns
                            "--no-heading",
                            "--color=always",
                            "--smart-case",
                            "--glob", "!.git/",
                            "--glob", "!*.lock",
                        }

                        local ignore_opts = get_cached_ignore_files()
                        return table.concat(vim.iter({ base_opts, ignore_opts }):flatten():totable(), " ")
                    end,
                    cwd = get_neotree_root,
                    prompt = "Live Grep > ",
                    input_prompt = "Grep for >",
                    silent = true,
                    actions = {
                        ["default"] = require("fzf-lua.actions").file_edit,
                    },
                },
                keymap = {
                    builtin = {
                        ["<C-u>"] = "preview-page-up",   -- scroll up preview
                        ["<C-d>"] = "preview-page-down", -- scroll down preview
                    },
                    fzf = {
                        ["ctrl-u"] = "preview-page-up",   -- fallback for fzf bindings
                        ["ctrl-d"] = "preview-page-down", -- fallback for fzf bindings
                    },
                },
            })
            -- Replace Telescope bindings with fzf-lua
            vim.keymap.set(
                "n", "gd",
                "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>",
                { desc = "Go to definition" }
            )
            vim.keymap.set("n", "gr",
                "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
                { desc = "Go to references" })

            vim.keymap.set("n", "gI",
                "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
                { desc = "Go to implementation" })

            vim.keymap.set("n", "<leader>D",
                "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>",
                { desc = "Go to type definition" })

            vim.keymap.set("n", "<leader>fa", "<cmd>FzfLua lsp_document_symbols<cr>",
                { desc = "Find symbols in current buffer" })

            vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol across project" })
            vim.keymap.set("n", "<leader>ff",
                function()
                    require("fzf-lua").files({
                        prompt = "Find Files>",
                    })
                end, { desc = "find files" })
            vim.keymap.set("n", "<leader>fd",
                function()
                    require("fzf-lua").files({
                        cwd = vim.fn.input("dir > "),
                        prompt = "Find Files>",
                    })
                end,
                { desc = "Find files in dir" })
            vim.keymap.set(
                "n", "<leader>fs",
                function()
                    require("fzf-lua").grep_cword({ search = vim.fn.input("Grep > ") })
                end, { desc = "Project content search (regex)" }
            )
            vim.keymap.set("n", "<leader>fv", "<cmd>FzfLua help_tags<cr>", { desc = "Find help tags" })
            local function project_live_grep()
                require("fzf-lua").live_grep({
                    cmd = "rg",
                    rg_opts = {
                        "--hidden",
                        "--column",
                        "--line-number",
                        "--no-heading",
                        "--color=always",
                        "--smart-case",
                        "--glob=!.git/",
                        "--glob=!*.lock",
                    },
                    cwd = get_neotree_root(),
                    prompt = "Live Grep > ",
                    input_prompt = "Grep for > ",
                    silent = true,
                    actions = {
                        ["default"] = require("fzf-lua.actions").file_edit,
                    },
                })
            end
            vim.keymap.set("n", "<leader>fp", project_live_grep, { desc = "Live grep content" })

            vim.keymap.set("n", "<leader>f$", "<cmd>FzfLua registers<cr>", { desc = "Search Vim registers" })
            vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua grep_curbuf<cr>", { desc = "Search current buffer" })
            vim.keymap.set("n", "<leader>fc", function()
                require("fzf-lua").files({
                    prompt = "Find NVIM Config> ",
                    cwd = vim.fn.expand("~/.config/nvim/"), -- Set the root directory
                })
            end, { desc = "Find files in Neovim config" })
            vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Search recent files" })
        end,
    }
}
