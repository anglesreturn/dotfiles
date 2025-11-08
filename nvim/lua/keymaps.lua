vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>wv', ':vsplit<cr>', { desc = 'Window vertical split' })
vim.keymap.set('n', '<leader>wh', ':split<cr>', { desc = 'Window horizontal split' })
vim.keymap.set('n', '<leader>wq', ':q<cr>', { desc = 'Window quit' })
vim.keymap.set('n', '<leader>ww', ':w<cr>', { desc = 'Window write' })

vim.keymap.set('t', '<C-\\><C-n>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: move to left window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Terminal: move to below window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Terminal: move to above window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: move to right window' })

vim.keymap.set('n', '<C-Tab>', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-S-Tab>', ':bprevious<cr>', { desc = 'Previous buffer' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})
