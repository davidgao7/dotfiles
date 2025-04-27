return {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
        -- your configuration comes here

        -- Kulala UI keymaps, override with custom keymaps as required (check docs or {plugins_path}/kulala.nvim/lua/kulala/config/keymaps.lua for details)
        ---@type boolean|table
        kulala_keymaps = true,
        --[[
        {
          ["Show headers"] = { "H", function() require("kulala.ui").show_headers() end, },
        }
          ]]

        curl_path = "/usr/bin/curl",

        -- additional cURL options
        -- see: https://curl.se/docs/manpage.html
        additional_curl_options = {},

        -- gRPCurl path, get from https://github.com/fullstorydev/grpcurl.git
        grpcurl_path = "/opt/homebrew/bin/grpcurl",

        -- websocat path, get from https://github.com/vi/websocat.git
        websocat_path = "/opt/homebrew/bin/websocat",

        -- openssl path
        openssl_path = "/usr/bin/openssl",

        -- set scope for environment and request variables
        -- possible values: b = buffer, g = global
        environment_scope = "b",

        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",

        -- enable reading vscode rest client environment variables
        vscode_rest_client_environmentvars = false,

        -- default timeout for the request, set to nil to disable
        request_timeout = nil, -- number for ms
        -- continue running requests when a request failure is encountered
        halt_on_error = true,

        -- certificates
        --[[
        --A hash array of certificates to be used for requests.

        The key is the hostname and optional the port. If no port is given, the certificate will be used for all ports where no dedicated one is defined.

        Each certificate definition needs

            - cert the path to the certificate file
            - key the path to the key files

        --]]
        certificates = {},

        -- Specify how to escape query parameters
        -- possible values: always, skipencoded = keep %xx as is
        urlencode = "always",

        -- default formatters/pathresolver for different content types
        contenttypes = {
            ["application/json"] = {
                ft = "json",
                formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
                pathresolver = function(...)
                    return require("kulala.parser.jsonpath").parse(...)
                end,
            },
            ["application/xml"] = {
                ft = "xml",
                formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "-" },
                pathresolver = vim.fn.executable("xmllint") == 1 and { "xmllint", "--xpath", "{{path}}", "-" },
            },
            ["text/html"] = {
                ft = "html",
                formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "--html", "-" },
                pathresolver = nil,
            },
        },

        ui = {
            -- display mode: possible values: "split", "float"
            display_mode = "split",
            -- split direction: possible values: "vertical", "horizontal"
            split_direction = "vertical",
            -- window options to override defaults: width/height/split/vertical
            win_opts = {},
            -- default view: "body" or "headers" or "headers_body" or "verbose" or fun(response: Response)
            default_view = "body",
            -- enable winbar
            winbar = true,
            -- Specify the panes to be displayed by default
            -- Current available pane contains { "body", "headers", "headers_body", "script_output", "stats", "verbose", "report", "help" },
            default_winbar_panes = { "body", "headers", "headers_body", "verbose", "script_output", "report", "help" },
            -- enable/disable variable info text
            -- this will show the variable name and value as float
            -- possible values: false, "float"
            show_variable_info_text = false,
            -- icons position: "signcolumn"|"on_request"|"above_request"|"below_request" or nil to disable
            show_icons = "on_request",
            -- default icons
            icons = {
                inlay = {
                    loading = "⏳",
                    done = "✅",
                    error = "❌",
                },
                lualine = "🐼",
                textHighlight = "WarningMsg", -- highlight group for request elapsed time
                lineHighlight = "Normal",
            },

            -- enable/disable request summary in the output window
            show_request_summary = true,
            -- disable notifications of script output
            disable_script_print_output = false,

            report = {
                -- possible values: true | false | "on_error"
                show_script_output = true,
                -- possible values: true | false | "on_error" | "failed_only"
                show_asserts_output = true,
                -- possible values: true | false | "on_error"
                show_summary = true,

                headersHighlight = "Special",
                successHighlight = "String",
                errorHighlight = "Error",
            },

            -- scratchpad default contents
            scratchpad_default_contents = {
                "@MY_TOKEN_NAME=my_token_value",
                "",
                "# @name scratchpad",
                "POST https://httpbin.org/post HTTP/1.1",
                "accept: application/json",
                "content-type: application/json",
                "",
                "{",
                '  "foo": "bar"',
                "}",
            },

            disable_news_popup = false,

            -- enable/disable built-in autocompletion
            autocomplete = true,

            -- enable/disable lua syntax highlighting in HTTP scripts
            lua_syntax_hl = true,
        },

        -- set to true to enable default keymaps (check docs or {plugins_path}/kulala.nvim/lua/kulala/config/keymaps.lua for details)
        -- or override default keymaps as shown in the example below.
        ---@type boolean|table
        global_keymaps = false,
    },
    config = function(_, opts)
        require("kulala").setup(opts)

        -- make neovim recognize files with the `.http` extension as HTTP files
        vim.filetype.add({
            extension = {
                ["http"] = "http",
            }
        })
    end,
    keys = {
        { "<leader>R",  "",                                                         desc = "+Rest" },
        { "<leader>Rb", function() require('kulala').scratchpad() end,              desc = "Open scratchpad" },
        { "<leader>Rc", function() require('kulala').copy() end,                    desc = "Copy as cURL" },
        { "<leader>RC", function() require('kulala').from_curl() end,               desc = "Paste from cURL" },
        { "<leader>Rg", function() require('kulala').download_graphql_schema() end, desc = "Download GraphQL schema" },
        { "<leader>Ri", function() require('kulala').inspect() end,                 desc = "Inspect current request" },
        { "<leader>Rn", function() require('kulala').jump_next() end,               desc = "Jump to next request" },
        { "<leader>Rp", function() require('kulala').jump_prev() end,               desc = "Jump to previous request" },
        { "<leader>Rq", function() require('kulala').close() end,                   desc = "Close Kulala window" },
        { "<leader>Rr", function() require('kulala').replay() end,                  desc = "Replay last request" },
        { "<leader>Rs", function() require('kulala').run() end,                     desc = "Send the request" },
        { "<leader>RS", function() require('kulala').show_stats() end,              desc = "Show request stats" },
        { "<leader>Rt", function() require('kulala').toggle_view() end,             desc = "Toggle body/header view" },
    },

}
