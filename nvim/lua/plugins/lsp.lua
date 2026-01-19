return {
  -- LSP config
  {

    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp', 'b0o/schemastore.nvim' },
    -- LazyVim merges this opts table into its own
    opts = function(_, opts)
      ------------------------------------------------------------------
      -- safe to require here: lspconfig is already on the runtimepath
      ------------------------------------------------------------------
      local util = require 'lspconfig.util'

      ------------------------------------------------------------------
      -- PYTHON --------------------------------------------------------
      ------------------------------------------------------------------
      opts.servers = opts.servers or {}

      -- completion & basic type-stubs
      opts.servers.pyright = opts.servers.pyright
        or {
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
        }

      -- Ruff ≥ 0.4 — built-in server (fast Rust rewrite)
      opts.servers.ruff = {
        cmd = { 'ruff', 'server' }, -- add "--preview" only if Ruff < 0.5.3
        root_dir = util.root_pattern( -- stop ruff from escaping your repo
          'pyproject.toml',
          '.ruff.toml',
          'ruff.toml',
          '.git'
        ),
        settings = { -- CLI flags go here
          args = {
            '--config',
            vim.fn.expand '~/.config/ruff/ruff.toml',
          },
        },
      }

      ------------------------------------------------------------------
      -- LUA / JSON (unchanged from your file) -------------------------
      ------------------------------------------------------------------
      opts.servers.lua_ls = opts.servers.lua_ls
        or {
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
        }

      opts.servers.jsonls = opts.servers.jsonls
        or {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        }

      ------------------------------------------------------------------
      -- BASH — *without* Makefiles so tabs survive --------------------
      ------------------------------------------------------------------
      opts.servers.bashls = { filetypes = { 'sh', 'bash', 'zsh' } }
    end,
    config = function(_, opts)
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
          map('<leader>ld', vim.lsp.buf.definition, 'Go to definition')
          map('<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
          map('<leader>lI', vim.lsp.buf.implementation, 'Go to implementation')
          map('<leader>ls', vim.lsp.buf.signature_help, 'Show function signature help')
          map(
            '<leader>li',
            function()
              vim.lsp.buf.code_action {
                apply = true,
                context = {
                  only = { 'source.organizeImports' },
                  diagnostics = {},
                },
              }
            end,
            'Organize imports'
          )

          map('<leader>fr', require('telescope.builtin').lsp_references, 'Find references')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
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

      -- show diagnostics on cursor hold
      vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
          if vim.fn.mode() ~= 'i' then
            vim.diagnostic.open_float(nil, { focus = false })
          end
        end,
      })

      -- setup all LSP servers using new vim.lsp.config API
      for name, cfg in pairs(opts.servers or {}) do
        cfg.capabilities = get_capabilities(name)
        vim.lsp.config[name] = cfg
        vim.lsp.enable(name)
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
              checkOnSave = {
                command = 'clippy',
                extraArgs = { '--', '-A', 'clippy::too_many_arguments' },
              },
              procMacro = { enable = true },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = false,
                },
              },
              files = {
                watcher = 'client',
              },
            },
          },
          on_attach = function(client, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Rust: ' .. desc })
            end
            map('<leader>le', '<cmd>RustExpandMacro<CR>', 'Expand Rust Macro')
            map('<leader>lm', '<cmd>RustHoverActions<CR>', 'Rust Hover Actions')
            map('<leader>lt', '<cmd>RustTest<CR>', 'Run Rust Tests')

            vim.bo[bufnr].buftype = ''
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
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
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
        mode = { 'n', 'v' },
        desc = 'Format buffer or selection',
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
        python = { 'ruff_format' },
        json = { 'jq' },
        sh = { 'shfmt' },
        make = {},
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
      }

      -- auto-run linting on save
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        callback = function()
          if vim.bo.filetype == 'rust' then return end

          require('lint').try_lint()
        end,
      })
    end,
  },
}
