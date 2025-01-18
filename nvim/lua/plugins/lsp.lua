return {
  -- language server configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    opts = {
      servers = {
        ruff = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<leader>la',
              vim.lsp.buf.code_action,
              { desc = 'Code Action', buffer = bufnr })
          end
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
              telemetry = { enable = false }
            }
          }
        }
      }
    },
    -- set capabilities for each server dynamically
    config = function(_, opts)
      local lspconfig = require 'lspconfig'

      vim.diagnostic.config({
        update_in_insert = false, -- stop diagnostics while typing
        virtual_text = false,
        float = { border = "rounded" },
        severity_sort = true,
      })

      vim.o.updatetime = 250

      -- ensure diagnostics only appear in normal mode and on hover
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        callback = function()
          if vim.fn.mode() ~= "i" then
            vim.diagnostic.open_float(nil, { focus = false })
          end
        end,
      })

      for server, config in pairs(opts.servers or {}) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end
  },
  {
    'saghen/blink.cmp',
    version = "v0.9.0",
    event = { 'LspAttach' },
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'mono' },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
    opts_extend = { "sources.default" }
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end
  },
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = 'Format buffer'
      }
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        return {
          timeout_ms = 500,
          lsp_fallback = vim.bo[bufnr].filetype ~= 'c' and vim.bo[bufnr].filetype ~= 'cpp'
        }
      end,
      formatters_by_ft = {
        lua = {
          command = "stylua",
          args = { "--config-path", vim.fn.expand("~/.config/nvim/.stylua.toml") }
        }
      }
    }
  },
  {
    'mfussenegger/nvim-lint',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require('lint')

      lint.linters.mypy.args = {
        "--ignore-missing-imports",
        "--follow-imports=silent",
        "--show-column-numbers"
      }

      lint.linters_by_ft = {
        python = { "mypy" }
      }

      -- Auto-run linting on save
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end
      })
    end
  }
}
