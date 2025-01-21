return {
  -- LSP config 
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp', 'b0o/schemastore.nvim' },
    opts = {
      servers = {
        -- python (ruff)
        ruff = {},

        -- lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
              telemetry = { enable = false }
            }
          }
        },

        -- rust (rustacean)
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              procMacro = { enable = true },
              cargo = { allFeatures = true },
            }
          }
        },

        -- json
        jsonls = {
          settings = function()
            local schemastore = require("schemastore")
            return {
              json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true },
              },
            }
          end
        },

        -- bash
        bashls = {
          filetypes = { "sh", "bash", "zsh", "Makefile" }
        }
      }
    },

    config = function(_, opts)
      local lspconfig = require 'lspconfig'

      -- attach keybindings to all LSPs dynamically
      local function on_attach(_, bufnr)

        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show hover information" })
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Show available code actions" })
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
        vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Show function signature help" })

        -- language-specific bindings
        local filetype = vim.bo[bufnr].filetype

        if filetype == "rust" then
          vim.keymap.set("n", "<leader>le", "<cmd>RustExpandMacro<CR>", { buffer = bufnr, desc = "Expand Rust macro" })
          vim.keymap.set("n", "<leader>lm", "<cmd>RustHoverActions<CR>", { buffer = bufnr, desc = "Rust hover actions" })
          vim.keymap.set("n", "<leader>lt", "<cmd>RustTest<CR>", { buffer = bufnr, desc = "Run Rust tests" })
        end
      end

      vim.diagnostic.config({
        update_in_insert = false, -- stop diagnostics while typing
        virtual_text = false,
        float = { border = "rounded" },
        severity_sort = true,
      })

      -- diagnostics only in normal mode and on hover
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        callback = function()
          if vim.fn.mode() ~= "i" then
            vim.diagnostic.open_float(nil, { focus = false })
          end
        end,
      })

      -- setup all lsp servers 
      for server, config in pairs(opts.servers or {}) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
    end
  },

  -- json schema support 
  {
    "b0o/schemastore.nvim",
  },

  -- rustacean 
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
      tools = {
        hover_actions = { auto_focus = true },
      },
      server = {}
    }
  },

  -- blink auto comp
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

  -- auto complete (SQL only) 
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'kristijanhusak/vim-dadbod-completion' -- Database completion source
    }
  },

  -- auto-pairing brackets
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end
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
        lua = { "stylua" },
        rust = { "rustfmt" }
      }
    }
  },

  -- linting 
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
        python = { "mypy" },
        rust = { "clippy" }
      }

      -- auto-run linting on save
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end
      })
    end
  }
}
