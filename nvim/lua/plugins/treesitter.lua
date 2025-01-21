-- https://github.com/adibhanna/nvim/blob/main/lua/plugins/nvim-treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Modules (optional but diagnostic may expect it)
        modules = {},

        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        sync_install = false,

        -- List of parsers to install
        ensure_installed = { 'lua', 'python', 'javascript', 'html', 'css', 'json', 'regex' }, -- Add your languages here

        -- List of parsers to ignore installing
        ignore_install = {},

        -- Highlighting
        highlight = {
          enable = true,
        },

        -- Text objects
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Jump forward to textobj, like targets.vim
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
              ['as'] = {
                query = '@local.scope',
                query_group = 'locals',
                desc = 'Select language scope',
              },
            },
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = true,
          },
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
}
