return {
  -- LSP config
  {

    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp', 'b0o/schemastore.nvim' },
    opts = {
      servers = {
        -- python auto-complete only (pyright)
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'none',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'off',
              },
            },
          },
        },

        -- python linter / formatter (ruff)
        ruff = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        },

        -- lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
              format = { enable = true },
            },
          },
        },

        -- json
        jsonls = {
          settings = function()
            local schemastore = require 'schemastore'
            return {
              json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true },
              },
            }
          end,
        },

        -- bash
        bashls = {
          filetypes = { 'sh', 'bash', 'zsh', 'Makefile' },
        },
      },
    },

    config = function(_, opts)
      local lspconfig = require 'lspconfig'

      -- per server capabilities
      local function get_capabilities(server)
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        if server == 'vim-dadbod-completion' and pcall(require, 'cmp_nvim_lsp') then
          capabilities = require('cmp_nvim_lsp').default_capabilities()
        elseif pcall(require, 'blink.cmp') then
          capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        end

        return capabilities
      end

      -- re-runs on every buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf
          local server = client and client.name or ''

          -- apply capabilities to the server
          if client then client.capabilities = get_capabilities(server) end

          -- keymaps
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          map('K', vim.lsp.buf.hover, 'Show hover information')
          map('<leader>la', vim.lsp.buf.code_action, 'Show available code actions')
          map('<leader>ld', vim.lsp.buf.definition, 'Go to definition')
          map('<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
          map('<leader>li', vim.lsp.buf.implementation, 'Go to implementation')
          map('<leader>ls', vim.lsp.buf.signature_help, 'Show function signature help')

          map('<leader>fr', require('telescope.builtin').lsp_references, 'Find references')
          map('<leader>la', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          map('<leader>lc', vim.lsp.buf.declaration, 'Goto Declaration')
        end,
      })

      -- diagnostics settings
      vim.diagnostic.config {
        update_in_insert = false, -- stop diagnostics while typing
        virtual_text = false,
        float = { border = 'rounded' },
        severity_sort = true,
      }

      -- show in normal mode (not insert) and on hover
      vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
          if vim.fn.mode() ~= 'i' then vim.diagnostic.open_float(nil, { focus = false }) end
        end,
      })

      -- setup all LSP servers
      for server, config in pairs(opts.servers or {}) do
        lspconfig[server].setup(config)
      end
    end,
  },

  -- json schema support
  {
    'b0o/schemastore.nvim',
  },

  -- rustacean
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    ft = { 'rust' },
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = { auto_focus = true },
        },
        server = {
          default_settings = {
            ['rust-analyzer'] = {
              checkOnSave = { command = 'clippy' },
              procMacro = { enable = true },
              cargo = { allFeatures = true },
            },
          },
          on_attach = function(client, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Rust: ' .. desc })
            end
            map('<leader>le', '<cmd>RustExpandMacro<CR>', 'Expand Rust Macro')
            map('<leader>lm', '<cmd>RustHoverActions<CR>', 'Rust Hover Actions')
            map('<leader>lt', '<cmd>RustTest<CR>', 'Run Rust Tests')
          end,
        },
      }
    end,
  },

  -- blink auto comp
  {
    'saghen/blink.cmp',
    version = 'v0.9.0',
    event = { 'LspAttach' },
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
    opts_extend = { 'sources.default' },
  },

  -- auto complete (SQL only)
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'kristijanhusak/vim-dadbod-completion', -- Database completion source
    },
  },

  -- auto-pairing brackets
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function() require('nvim-autopairs').setup {} end,
  },

  -- auto-formatting
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>lf',
        function() require('conform').format { async = true, lsp_fallback = true } end,
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        return {
          timeout_ms = 500,
          lsp_fallback = vim.bo[bufnr].filetype ~= 'rust', -- Ensure rustfmt is used over LSP
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        json = { 'jq' },
        sh = { 'shfmt' },
        make = { 'just' },
        toml = { 'taplo' },
      },
    },
  },

  -- linting
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters.mypy.args = {
        '--ignore-missing-imports',
        '--follow-imports=silent',
        '--show-column-numbers',
      }

      lint.linters_by_ft = {
        python = { 'mypy' },
        rust = { 'clippy' },
      }

      -- auto-run linting on save
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        callback = function() require('lint').try_lint() end,
      })
    end,
  },
}
