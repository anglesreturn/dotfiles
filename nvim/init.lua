-- set before any requires
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- install lazy.nvim
require 'config.lazy'

-- [[ Setting Options ]]
require 'options'

-- [[ Setting Keymaps ]]
require 'keymaps'
