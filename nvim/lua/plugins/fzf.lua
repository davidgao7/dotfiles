-- Wrap in a module-like table
local fzf_cache = {
    ignore_opts_cache = nil
}

-- Expose it globally for other files (like options.lua) to use
_G.fzf_cache = fzf_cache

local function get_neotree_root()
    require("lazy").load({ plugins = { "neo-tree.nvim" } })
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
    local is_dir = vim.fn.isdirectory(filepath) == 1
    if is_dir then
        return { "ls", "-la", filepath }
    end
    local image_exts = { png = true, jpg = true, jpeg = true, gif = true, bmp = true, webp = true }
    if image_exts[ext] then
        return { "/opt/homebrew/bin/chafa", "--fill=block", "--symbols=block", "--size=80x40", filepath }
    end
    if ext == "pdf" then
        return { "/opt/homebrew/bin/pdftotext", filepath, "-" }
    end
    return { "/opt/homebrew/bin/bat", "--style=numbers", "--color=always", "--wrap=character", filepath }
end

vim.api.nvim_create_user_command("FzfIgnoreCacheClear", function()
    _G.fzf_cache.ignore_opts_cache = nil
    vim.notify("fzf-lua ignore cache manually cleared", vim.log.levels.INFO)
end, { desc = "Clear fzf-lua ignore file cache" })

vim.api.nvim_create_user_command("FzfReloadIgnore", function()
    _G.fzf_cache.ignore_opts_cache = get_existing_ignore_files()
    vim.notify("fzf-lua ignore cache reloaded manually", vim.log.levels.INFO)
end, { desc = "Manually reload ignore files into fzf-lua cache" })

local function get_cached_ignore_files()
    if not fzf_cache.ignore_opts_cache then
        fzf_cache.ignore_opts_cache = get_existing_ignore_files()
    end
    return fzf_cache.ignore_opts_cache
end

return {
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-neo-tree/neo-tree.nvim",
        },
        config = function()
            require("fzf-lua").setup({
                winopts = {
                    height = 0.85,
                    width = 0.85,
                    border = "rounded",
                    preview = {
                        layout = "flex",
                        flip_columns = 120,
                        scrollbar = true,
                        title = true,
                        delay = 100,
                        builtin = {
                            title = true,
                            scrollbar = true,
                            delay = 100,
                            fn = function(filepath, bufnr, opts)
                                local preview_cmd = universal_previewer(filepath)
                                if preview_cmd then
                                    require("fzf-lua.previewer").cmd_sync(preview_cmd, bufnr, opts)
                                else
                                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false,
                                        { "No preview available for this file type." })
                                end
                            end,
                        },
                    },
                },
                -- display git status in the preview window
                files = {
                    previewer = "builtin",
                    cwd = get_neotree_root(),
                    git_status = true,  -- ensure it tries to fetch git status
                    git_icons = true,   -- Show Git status icons
                    file_icons = true,  -- Show file type icons
                    color_icons = true, -- Enable color for icons

                    -- To match Neo-tree's Git status color display
                    formatter = "path.filename_first", -- optional: controls layout
                },
                grep = {
                    rg_cmd = "rg",
                    rg_opts = function()
                        local base_opts = {
                            "--hidden",
                            "--column",
                            "--line-number",
                            "--no-heading",
                            "--color=always",
                            "--smart-case",
                            "--glob", "!.git/",
                            "--glob", "!*.lock",
                        }
                        local ignore_opts = get_cached_ignore_files()
                        return table.concat(vim.iter({ base_opts, ignore_opts }):flatten():totable(), " ")
                    end,
                    cwd = get_neotree_root(),
                    prompt = "Rg Live Grep> ",
                    input_prompt = "Grep for >",
                    silent = true,
                    actions = {
                        ["default"] = require("fzf-lua.actions").file_edit,
                    },
                },
                live_grep = {
                    rg_cmd = "rg",
                    rg_opts = function()
                        local base_opts = {
                            "--hidden",
                            "--column",
                            "--line-number",
                            "--no-heading",
                            "--color=always",
                            "--smart-case",
                            "--glob", "!.git/",
                            "--glob", "!*.lock",
                        }
                        local ignore_opts = get_cached_ignore_files()
                        return table.concat(vim.iter({ base_opts, ignore_opts }):flatten():totable(), " ")
                    end,
                    cwd = get_neotree_root(),
                    prompt = "Live Grep > ",
                    input_prompt = "Grep for >",
                    silent = true,
                    actions = {
                        ["default"] = require("fzf-lua.actions").file_edit,
                    },
                },
                keymap = {
                    builtin = {
                        ["<C-u>"] = "preview-page-up",
                        ["<C-d>"] = "preview-page-down",
                    },
                    fzf = {
                        ["ctrl-u"] = "preview-page-up",
                        ["ctrl-d"] = "preview-page-down",
                    },
                },
            })

            vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>",
                { desc = "Go to definition" })
            vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
                { desc = "Go to references" })
            vim.keymap.set("n", "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
                { desc = "Go to implementation" })
            vim.keymap.set("n", "<leader>D", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>",
                { desc = "Go to type definition" })
            vim.keymap.set("n", "<leader>fa", "<cmd>FzfLua lsp_document_symbols<cr>",
                { desc = "Find symbols in current buffer" })
            vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol across project" })
            local function smart_find_files()
                local root = get_neotree_root()
                if vim.fn.isdirectory(root .. "/.git") == 1 then
                    require("fzf-lua").git_files({ cwd = root, prompt = "Git Files>" })
                else
                    require("fzf-lua").files({ cwd = root, prompt = "Find Files>" })
                end
            end
            vim.keymap.set("n", "<leader>ff", smart_find_files, { desc = "Smart Find Files" })
            vim.keymap.set("n", "<leader>fd", function()
                require("fzf-lua").files({ cwd = vim.fn.input("dir > "), prompt = "Find Files>" })
            end, { desc = "Find files in dir" })
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
            vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua grep_curbuf<CR>", { desc = "Search current buffer" })
            vim.keymap.set("n", "<leader>fc", function()
                require("fzf-lua").files({ prompt = "Find NVIM Config> ", cwd = vim.fn.expand("~/.config/nvim/") })
            end, { desc = "Find files in Neovim config" })
            vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Search recent files" })
        end,
    }
}
