return {
    run = function()
        vim.cmd("redraw")

        -- Safely defer this so it waits until plugins are fully loaded
        vim.schedule(function()
            local ok, lazy_core = pcall(require, "lazy.core.loader")
            if ok and lazy_core.plugins then
                require("lazy").load({ wait = true }) -- now it's safe!
            end

            local keymaps = {}
            local modes = { "n", "i", "v", "x", "s", "o", "t", "c" }
            for _, mode in ipairs(modes) do
                for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
                    local lhs = map.lhs
                    local rhs = map.rhs or "[N/A]"
                    local desc = map.desc or ""
                    local plugin = map.plugin or "NA"
                    local line = string.format("[%s] %s -> %s (%s) [%s]", mode, lhs, rhs, desc, plugin)
                    table.insert(keymaps, line)
                end
            end
            local lazy_plugins = require("lazy.core.config").spec
            for _, plugin in pairs(lazy_plugins) do
                if plugin.keys then
                    for _, map in ipairs(plugin.keys) do
                        local lhs = type(map) == "table" and map[1] or map
                        local desc = type(map) == "table" and (map.desc or "") or ""
                        table.insert(keymaps, string.format("[lazy] %s -> %s (%s)", lhs, "[lazy plugin]", desc))
                    end
                end
            end

            require("plugins.fzf") -- ensure fzf-lua is loaded
            require("fzf-lua").fzf_exec(keymaps, {
                prompt = "Keymaps> ",
                previewer = function(item)
                    return vim.fn.systemlist(string.format("echo '%s'", item))
                end,
            })
        end)
    end
}
