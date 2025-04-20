return {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "latex" },
    init = function()
        -- Avoid Zathura opening a new window on every save:
        vim.g.vimtex_view_automatic = 1
        vim.g.vimtex_view_automatic_once = 1

        -- 🧼 Temporary build directory
        local temp_build_dir = vim.fn.stdpath("cache") .. "/vimtex_tmp_" .. tostring(math.random(10000, 99999))
        vim.fn.mkdir(temp_build_dir, "p")

        local function custom_vimtex_view()
            local name = vim.fn.expand("%:t:r")
            local pdf = temp_build_dir .. "/" .. name .. ".pdf"
            if vim.fn.filereadable(pdf) == 1 then
                vim.notify("Opening PDF: " .. pdf, vim.log.levels.INFO, { title = "VimTeX View" })
                os.execute("zathura '" .. pdf .. "' &")
            else
                vim.notify("PDF not found: " .. pdf, vim.log.levels.WARN, { title = "VimTeX View" })
            end
        end

        -- Register command and <leader>vv keymap
        vim.api.nvim_create_user_command("VimtexView", custom_vimtex_view, {})
        vim.keymap.set("n", "<leader>vv", custom_vimtex_view, { desc = "📄 View PDF with Zathura" })

        vim.keymap.set("n", "<leader>vt", function()
            vim.cmd("edit " .. temp_build_dir)
        end, { desc = "🧪 Open VimTeX Temp Dir" })

        -- 🛠 Compiler config (force xelatex)
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk_engines = {
            _ = '-xelatex',
        }
        vim.g.vimtex_compiler_latexmk = {
            executable = 'latexmk',
            options = {
                '-interaction=nonstopmode',
                '-file-line-error',
                '-synctex=1',
                '-outdir=' .. temp_build_dir,
            },
            callback = 1,
            continuous = 1,
        }


        -- 🧹 Clean path + hook for VimtexClean
        vim.g.vimtex_compiler_clean_paths = { vim.fn.stdpath("cache") .. "/vimtex_tmp_*" }


        vim.api.nvim_create_autocmd("User", {
            pattern = "VimtexEventClean",
            callback = function()
                for _, dir in ipairs(vim.fn.glob(vim.fn.stdpath("cache") .. "/vimtex_tmp_*", 1, 1)) do
                    vim.fn.delete(dir, "rf")
                end
                local link_dest = vim.fn.expand("%:p:h") .. "/" .. vim.fn.expand("%:t:r") .. ".pdf"
                if vim.fn.getftype(link_dest) == "link" then
                    vim.fn.delete(link_dest)
                end
            end,
        })

        -- 🗑 Clean up on Vim quit
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                vim.fn.delete(temp_build_dir, "rf")
                local link = vim.fn.expand("%:p:h") .. "/" .. vim.fn.expand("%:t:r") .. ".pdf"
                if vim.fn.getftype(link) == "link" then
                    vim.fn.delete(link)
                end
            end,
        })

        -- 🔗 Symlink PDF back to working directory
        vim.api.nvim_create_autocmd("User", {
            pattern = "VimtexEventCompileSuccess",
            callback = function()
                local pdf_out = temp_build_dir .. "/" .. vim.fn.expand("%:t:r") .. ".pdf"
                local link_dest = vim.fn.expand("%:p:h") .. "/" .. vim.fn.expand("%:t:r") .. ".pdf"
                if vim.fn.filereadable(pdf_out) == 1 then
                    vim.fn.delete(link_dest)
                    os.execute("ln -s " .. pdf_out .. " " .. link_dest)
                end
            end,
        })

        -- ❌ Show failure popup if compile fails
        vim.api.nvim_create_autocmd("User", {
            pattern = "VimtexEventCompileFailure",
            callback = function()
                vim.notify("❌ LaTeX compilation failed!", vim.log.levels.ERROR, { title = "VimTeX" })
            end,
        })

        -- ✅ Add PDF Preview on Save
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = "*.tex",
            callback = function()
                vim.defer_fn(custom_vimtex_view, 300)
            end,
        })


        -- 👓 Viewer setup (Zathura)
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_view_zathura_callback = function()
            local pdf = temp_build_dir .. "/" .. vim.fn.expand("%:t:r") .. ".pdf"
            if vim.fn.filereadable(pdf) == 1 then
                os.execute("zathura '" .. pdf .. "' &")
            else
                vim.notify("PDF not found: " .. pdf, vim.log.levels.WARN, { title = "VimTeX Zathura" })
            end
        end
        vim.g.vimtex_view_use_temp_files = true
        vim.g.vimtex_view_general_viewer = "zathura"
        vim.g.vimtex_view_general_options = "--synctex-forward @line:1:@pdf @tex"
        vim.g.vimtex_view_zathura_options = "--synctex-forward @line:1:@pdf @tex 2>/dev/null"


        -- 🎯 Syntax, formatting, etc.
        vim.g.vimtex_syntax_enabled = 0
        vim.g.vimtex_indent_enabled = false
        vim.g.tex_indent_items = false
        vim.g.tex_indent_brace = false

        -- 🚫 Silence noisy warnings
        vim.g.vimtex_quickfix_mode = 0
        vim.g.vimtex_log_ignore = {
            "Underfull",
            "Overfull",
            "specifier changed to",
            "Token not allowed in a PDF string",
        }

        vim.g.vimtex_mappings_enabled = 1
        vim.g.tex_flavor = "latex"
    end,
    keys = {
        {
            "<leader>vx",
            "<cmd>VimtexClean<cr>",
            desc = "🧹 Clean build files",
        },
        {
            "<leader>vr",
            "<cmd>VimtexCompile<cr>",
            desc = "🔁 Compile LaTeX (continuous)",
        },
        {
            "<leader>vq",
            "<cmd>VimtexStop<cr>",
            desc = "🛑 Stop compiler",
        },
    },
}
