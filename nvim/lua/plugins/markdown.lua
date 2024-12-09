return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = { "markdown" }, -- Load only for Markdown files
  config = function()
    -- Set keymaps for Markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Toggle Markdown Preview", buffer = true })
        vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Stop Markdown Preview", buffer = true })
      end,
    })
  end,
}
