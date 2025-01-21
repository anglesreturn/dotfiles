return {
  'folke/which-key.nvim',
  event = "VimEnter",
  opts = {
    -- preset = "helix",
    delay = 0,
    icons = {
      rules = false,
      breadcrumb = " ", -- symbol used in the command line area that shows your active key combo
      separator = "󱦰  ", -- symbol used between a key and it's label
      group = "󰹍 ", -- symbol prepended to a group
    },
    show_keys = false,
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>g", group = "git" },
        { "<leader>r", group = "Replace" },
        -- { "<leader>l", group = "lsp" },
        { "<leader>t", group = "Test" },
        { "<leader>f", group = "Find" },
        { '<leader>x', group = 'Diagnostics', icon = { icon = '󱖫 ', color = 'green' } },
        { "<leader>l", group = "LSP" },
        { '<leader>s', group = 'Session' },
        -- { "<leader>g", group = "go" },
        { "<leader>w", group = "Workspace" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        -- { '<leader>c', group = '[c]ode' },
        -- { '<leader>r', group = '[r]eload' },
      },
    },
  },
}
