return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 10,
      open_mapping = [[<c-\>]],
      start_in_insert = true,
      direction = "float",  -- Can be "horizontal", "vertical", or "float"
      close_on_exit = true, -- Close terminal window when process exits
      shell = vim.o.shell,  -- Shell to use
      float_opts = {
        border = "curved",
        winblend = 5,
      },
    })

    local keymap = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true, desc = "" }

    keymap("n", "<leader>tt", "<cmd>ToggleTerm direction<CR>",
      vim.tbl_extend("force", opts, { desc = "Toggle terminal" })) -- Toggle terminal
    keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>",
      vim.tbl_extend("force", opts, { desc = "Vertical" }))        -- Vertical terminal
  end,
}
