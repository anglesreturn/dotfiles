return {
  'tpope/vim-dadbod',
  dependencies = {
    'kristijanhusak/vim-dadbod-ui',
    'kristijanhusak/vim-dadbod-completion'
  },
  event = "VeryLazy",
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        require('cmp').setup.buffer({
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
            { name = "lsp" }
          }
        })
      end
    })

     -- Keymaps for vim-dadbod-ui
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    map("n", "<leader>db", ":DBUIToggle<CR>", opts)
    map("n", "<leader>dn", ":DBUIAddConnection<CR>", opts)
    map("n", "<leader>dr", ":DBUIExecuteQuery<CR>", opts)
    map("n", "<leader>df", ":DBUIFindBuffer<CR>", opts)
    map("n", "<leader>dh", ":DBUIShowHelp<CR>", opts)

  end
}
