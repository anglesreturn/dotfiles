return {
  {
    'christoomey/vim-tmux-navigator',
  },
  {
    -- session management
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      {
        '<leader>sr',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>ss',
        function()
          require('persistence').select()
        end,
        desc = 'Select Session',
      },
      {
        '<leader>sl',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>sx',
        function()
          require('persistence').stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },

  -- auxillary functions
  { 'nvim-lua/plenary.nvim', lazy = true },
}
