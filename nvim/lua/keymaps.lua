vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>wv', ':vsplit<cr>', { desc = 'Window vertical split' })
vim.keymap.set('n', '<leader>wh', ':split<cr>', { desc = 'Window horizontal split' })
vim.keymap.set('n', '<leader>wq', ':q<cr>', { desc = 'Window quit' })
vim.keymap.set('n', '<leader>ww', ':w<cr>', { desc = 'Window write' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})
