return {
  {
    'christoomey/vim-tmux-navigator',
  },
  -- auxillary functions
  { 'nvim-lua/plenary.nvim', lazy = true },
  {
    'tpope/vim-surround',
  },
  {
    'axieax/urlview.nvim',
    config = function()
      require('urlview').setup {
        default_picker = 'telescope',
        default_action = 'system',
      }
      vim.keymap.set('n', '<leader>mu', ':UrlView<CR>', { desc = 'Find URLs' })
      vim.keymap.set('n', '<leader>mo', function()
        local url = vim.fn.expand '<cfile>'
        if url:match '^https?://' then
          vim.ui.open(url)
        else
          vim.notify('No URL under cursor', vim.log.levels.WARN)
        end
      end, { desc = 'Open URL under cursor' })
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup {
        use_default_keymaps = false,
      }
      vim.keymap.set('n', '<leader>j', require('treesj').toggle, { desc = 'Toggle split/join' })
    end,
  },
  -- {
  --   'mg979/vim-visual-multi',
  --   config = function()
  --     vim.g.VM_maps = {
  --       ['Select Cursor Down'] = '<C-d>',
  --       ['Select Cursor Up'] = '<C-u>',
  --     }
  --   end,
  -- },
}
