local ensure_installed_fmts = {
  "stylua",
  "ruff",
  "docformatter",
  "prettierd",
  "clang-format",
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
  "stevearc/conform.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "williamboman/mason.nvim",
  },
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },

  --- Setup keymaps here
  keys = {
    {
      "<leader>f",
      mode = "v",
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                "n",
                true
              )
            end
          end
        end)
      end,
      { desc = "Format selected code" },
    },

    {
      "<leader>uf",
      mode = "n",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format current buffer",
    },

    {
      "<leader>uF",
      mode = "n",
      function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        local status = vim.b.disable_autoformat and "disabled" or "enabled"
        vim.notify(
          "Autoformat-on-save " .. status .. " for this buffer",
          vim.log.levels.INFO,
          { title = "Conform.nvim" }
        )
      end,
      desc = "Toggle format-on-save for current buffer",
    },
  },

  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- add logs to vim messages
    log_level = vim.log.levels.WARN,
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff", "docformatter" },
      javascript = {
        "prettierd",
        stop_after_first = true,
      },
      typescript = {
        "prettierd",
        stop_after_first = true,
      },
      css = {
        "prettierd",
        stop_after_first = true,
      },
      html = {
        "prettierd",
        stop_after_first = true,
      },
      json = {
        "prettierd",
        "jq",
        stop_after_first = true,
      },
      yaml = {
        "yamlfmt",
        stop_after_first = true,
      },
      markdown = {
        "markdownlint-cli2",
        "markdown-toc",
        "prettierd",
        stop_after_first = true,
      },
      -- Other languages just one formatter, no need stop_after_first
      c = { "clang-format" },
      cpp = { "clang-format" },
      cs = { "csharpier" },
      rb = { "rubocop" },
      sh = { "shfmt" },
      go = { "gofumpt", "goimports", "golines" },
      java = { "google-java-format" },
    },
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      stylua = {
        prepend_args = function()
          local cfg = vim.fs.find({ ".stylua.toml", "stylua.toml" }, {
            upward = true,
            path = vim.api.nvim_buf_get_name(0),
          })[1]
          return cfg and { "--config-path", cfg } or {}
        end,
      },
    },

    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  },

  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,

  config = function(_, opts)
    -- maksure install the formatters from ensure_installed_fmts
    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed_fmts,
      auto_update = false,
      run_on_start = true,
      start_delay = 500, -- delay so Mason UI finishes loading
    })

    -- build formatter executable map
    local ok, mason_registry = pcall(require, "mason-registry")
    if not ok then
      vim.notify("mason-registry not found", vim.log.levels.ERROR, { title = "Conform.nvim" })
      return
    end

    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

    -- link the formatter installed in mason registry with conform
    for _, package in ipairs(mason_registry.get_installed_packages()) do
      local name = package.name

      if not opts.formatters[name] then
        -- check if the binary exists
        local executable = mason_bin .. name
        if vim.fn.executable(executable) == 1 then
          opts.formatters[name] = {
            command = executable,
          }
        end
      end
    end

    -- setup conform.nvim to toggle format on save
    require("conform").setup(opts)

    -- setup toggle commands
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}
