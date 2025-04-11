return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "toggle Neotree" })
            -- Setup Neo-tree with follow_current_file enabled
            require("neo-tree").setup({
                filesystem = {
                    follow_current_file = {
                        enabled = true,      -- Automatically focus the current file
                        leave_dirs_open = false, -- Close auto-expanded directories
                    },
                },
            })
        end
    }
}
