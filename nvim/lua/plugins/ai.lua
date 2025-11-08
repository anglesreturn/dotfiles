return {
  -- Codeium for cursor-style auto-completions
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {
        enable_chat = true,
        virtual_text = {
          enabled = true,
          key_bindings = {
            accept = '<Tab>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            clear = '<C-]>',
          },
        },
      }
    end,
  },

  -- Claude Code integration
  {
    'greggh/claude-code.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('claude-code').setup {
        terminal = {
          position = 'right',
          size = 80,
        },
        refresh = {
          auto_refresh = true,
          debounce_ms = 500,
        },
      }
    end,
    keys = {
      { '<leader>cc', '<cmd>ClaudeCodeToggle<cr>', desc = 'Claude Code: Toggle terminal' },
    },
  },
}
