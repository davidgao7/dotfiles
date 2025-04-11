local ensure_installed_fmts = {
    "stylua",
    "ruff",
    "docformatter",
    "prettierd",
    "clang-format",
    "cmake-format",
    "csharpier",
    "rubocop",
    "shfmt",
    "gofumpt",
    "goimports",
    "golines",
    "google-java-format",
    "yamlfmt",
    "markdownlint-cli2",
    "markdown-toc",
}

return {
    'stevearc/conform.nvim',
    dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "williamboman/mason.nvim",
    },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    vim.keymap.set('v', '<leader>f', function()
        require('conform').format({ async = true }, function(err)
            if not err then
                local mode = vim.api.nvim_get_mode().mode
                if vim.startswith(string.lower(mode), 'v') then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
                end
            end
        end)
    end, { desc = 'Format selected code' }),
    vim.keymap.set('n', '<leader>uf', function()
        require('conform').format { async = true }
    end, { desc = 'Format current buffer' }),

    -- keymaps for format enable/disable toggle
    vim.keymap.set("n", "<leader>uF", function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        local status = vim.b.disable_autoformat and "disabled" or "enabled"
        vim.notify("Autoformat-on-save " .. status .. " for this buffer", vim.log.levels.INFO, { title = "Conform.nvim" })
    end, { desc = "Toggle format-on-save for current buffer" }),

    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { 'stylua' },
            python = { 'ruff', 'docformatter' },
            javascript = { 'prettierd', stop_after_first = true },
            typescript = { 'prettierd', stop_after_first = true },
            css = { 'prettierd', stop_after_first = true },
            html = { 'prettierd', stop_after_first = true },
            json = { 'prettierd', stop_after_first = true },
            ymal = { 'yamlfmt', stop_after_first = true },
            markdown = { 'markdownlint-cli2', 'markdown-toc', 'prettierd' },
            c = { 'clang-format' },
            cpp = { 'clang-format' },
            cmake = { 'cmake_format' },
            cs = { 'csharpier' },
            rb = { 'rubocop' },
            sh = { 'shfmt' },
            go = { 'gofumpt', 'goimports', 'golines' },
            java = { 'google-java-format' },
        },
        -- Customize formatters
        formatters = {
            shfmt = {
                prepend_args = { '-i', '2' },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,

    config = function()
        -- maksure install the formatters
        require("mason-tool-installer").setup({
            ensure_installed = ensure_installed_fmts,
            auto_update = false,
            run_on_start = true,
            start_delay = 3000, -- delay so Mason UI finishes loading
        })

        -- toggle format on save
        require('conform').setup {
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_format = 'fallback' }
            end,
        }
        vim.api.nvim_create_user_command('FormatDisable', function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = 'Disable autoformat-on-save',
            bang = true,
        })
        vim.api.nvim_create_user_command('FormatEnable', function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = 'Re-enable autoformat-on-save',
        })
    end,
}
