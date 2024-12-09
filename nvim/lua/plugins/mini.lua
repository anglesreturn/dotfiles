local header_art = [[
   __ _  ___  ___      __   _(_)_ __ ___
  / _` |/ _ \/ _ \ ____\ \ / / | '_ ` _ \
 | (_| |  __/ (_) |_____\ V /| | | | | | |
  \__, |\___|\___/       \_/ |_|_| |_| |_|
  |___/
]]

return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.animate').setup()

    require('mini.move').setup()

    require('mini.files').setup {
      windows = {
        preview = true,
      },
    }
    vim.keymap.set(
      'n',
      '<leader>e',
      ':lua MiniFiles.open()<CR>',
      { noremap = true, silent = true, desc = 'File explorer' }
    )

    require('mini.notify').setup()

    local starter = require 'mini.starter'
    starter.setup {
      items = {
        starter.sections.recent_files(3, true),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning('center', 'center'),
      },
      header = header_art,
    }

    require('mini.icons').setup {}
  end,
}
