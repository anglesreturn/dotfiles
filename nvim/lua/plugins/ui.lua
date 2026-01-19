return {
  {
    'vague-theme/vague.nvim',
    config = function()
      require('vague').setup {}
      vim.cmd.colorscheme 'vague'
    end,
  },
  -- {
  --   'rebelot/kanagawa.nvim',
  --   config = function() vim.cmd.colorscheme 'kanagawa-wave' end,
  -- },
  -- {
  --   'sainnhe/gruvbox-material',
  --   enabled = true,
  --   priority = 1000,
  --   config = function()
  --     vim.g.gruvbox_material_transparent_background = 0
  --     vim.g.gruvbox_material_foreground = 'mix'
  --     vim.g.gruvbox_material_background = 'hard'
  --     vim.g.gruvbox_material_ui_contrast = 'high'
  --     vim.g.gruvbox_material_float_style = 'bright'
  --     vim.g.gruvbox_material_statusline_style = 'material'
  --     vim.g.gruvbox_material_cursor = 'auto'
  --
  --     -- vim.g.gruvbox_material_colors_override = { bg0 = '#16181A' } -- #0e1010
  --     -- vim.g.gruvbox_material_better_performance = 1
  --
  --     -- vim.cmd.colorscheme 'gruvbox-material'
  --   end,
  -- },
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim', -- Required dependency
  --   },
  --   config = function()
  --     require('noice').setup {
  --       cmdline = { enabled = true, view = 'cmdline_popup' },
  --     }
  --   end,
  -- },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'meuter/lualine-so-fancy.nvim',
    },
    enabled = true,
    lazy = false,
    event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
    config = function()
      local icons = require 'mini.icons'
      require('lualine').setup {
        options = {
          theme = 'auto',
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {},
          lualine_b = {
            'fancy_branch',
          },
          lualine_c = {
            {
              'filename',
              path = 1, -- 2 for full path
            },
            {
              'fancy_diagnostics',
              sources = { 'nvim_lsp' },
              symbols = { error = ' ', warn = ' ', info = ' ' },
            },
            { 'fancy_searchcount' },
          },
          lualine_x = {
            'fancy_lsp_servers',
            'fancy_diff',
          },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          -- lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'lazy' },
      }
    end,
  },
}
