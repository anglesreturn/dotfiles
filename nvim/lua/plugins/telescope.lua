return {
  -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function() return vim.fn.executable 'make' == 1 end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },

  config = function()
    require('telescope').setup {
      pickers = {
        buffers = {
          show_all_buffers = true,
          sort_lastused = true,
          theme = 'dropdown',
          previewer = false,
          mappings = { i = { ['<c-d>'] = 'delete_buffer' } },
        },
      },
      extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    vim.keymap.set(
      'n',
      '/',
      function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end,
      { desc = 'Find in current buffer' }
    )

    local builtin = require 'telescope.builtin'

    local keymaps = {
      { '<leader><leader>', builtin.buffers, desc = 'Find existing buffers' },
      { '<leader>fo', builtin.oldfiles, desc = 'Find recent files' },
      {
        '<leader>fc',
        function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end,
        desc = 'Find config files',
      },
      { '<leader>ff', builtin.find_files, desc = 'Find files - root' },
      {
        '<leader>fF',
        function() builtin.find_files { cwd = vim.fn.getcwd() } end,
        desc = 'Find files - cwd',
      },
      {
        '<leader>fh',
        function() builtin.find_files { cwd = vim.fn.expand '~' } end,
        desc = 'Find files - home',
      },
      { '<leader>fg', builtin.live_grep, desc = 'Find in project - grep' },
      {
        '<leader>fG',
        function() builtin.live_grep { grep_open_files = true } end,
        desc = 'Find in open files (grep)',
      },
      { '<leader>fk', builtin.keymaps, desc = 'Find keymaps' },
      { '<leader>fw', builtin.grep_string, desc = 'Find current word' },
      { '<leader>fd', builtin.diagnostics, desc = 'Find diagnositcs' },
      {
        '<leader>sr',
        function()
          builtin.live_grep {
            search_dirs = { vim.fn.expand '%:p' },
            prompt_title = 'Find & Replace in Current File',
          }
        end,
        desc = 'Search and replace in current file',
      },
    }

    for _, keymap in ipairs(keymaps) do
      vim.keymap.set('n', keymap[1], keymap[2], { desc = keymap.desc })
    end
  end,
}
