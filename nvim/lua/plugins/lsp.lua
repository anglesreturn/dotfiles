return {
  -- language server configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function(_, opts)
      local lspconfig = require 'lspconfig'
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- python
      lspconfig.ruff.setup {
        -- before_init = function(_, config)
        --   config.settings.python.pythonPath = get_current_path()
        -- end,
        capabilities = capabilities,
      }
      lspconfig.mypy.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.keymap.set('n', '<leader>la', function()
            vim.lsp.buf.code_action()
          end, { desc = 'Code Action', buffer = bufnr })
        end,
        settings = {
          python = {
            mypy = { enabled = true, live_mode = true, },
          },
        },
      }

      -- lua
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' }, },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = { enable = false, },
          },
        },
        capabilities = capabilities,
      }

      for server, config in pairs(opts.servers or {}) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end
    end,
  },

  -- auto-completion
  {
    'saghen/blink.cmp',
    event = { 'LspAttach' },
    opts = {
      keymap = { preset = 'super-tab' },
      highlight = { use_nvim_cmp_as_default = true, },
      accept = { auto_brackets = { enabled = true } },
    },
    opts_extend = { 'sources.completion.enabled_providers' },
  },

  -- auto-pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  -- auto-formatting
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = {
          command = "stylua",
          args = { "--config", vim.fn.expand("~/.stylua.toml") },
        },
      },
    },
  },
}
