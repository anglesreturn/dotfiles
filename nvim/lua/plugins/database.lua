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
  end
}
