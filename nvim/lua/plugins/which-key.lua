return {
  'folke/which-key.nvim',
  event = "VimEnter",
  opts = {
    -- preset = "helix",
    delay = 0,
    icons = {
      rules = false,
      breadcrumb = " ",
      separator = "󱦰  ",
      group = "󰹍 ",
    },
    show_keys = false,
    spec = {
      {
        mode = { "n", "v" },

        -- not groups
        -- { "<leader>e", "File Explorer", icon = { icon = " ", color = "yellow" } },
        -- { "<leader> ", "Buffers", icon = { icon = "󰿯 ", color = "blue" } },

        -- groups
        { "<leader>t", group = "Terminal", icon = { icon = " ", color = "cyan" } },
        { "<leader>d", group = "Database", icon = { icon = " ", color = "purple" } },
        { "<leader>f", group = "Find", icon = { icon = "󰱼 ", color = "green" } },
        { "<leader>g", group = "Git", icon = { icon = "󰊢 ", color = "red" } },
        { '<leader>x', group = 'Diagnostics', icon = { icon = '󱖫 ', color = 'green' } },
        { "<leader>l", group = "LSP", icon = { icon = " ", color = "blue" } },

        -- debugging inside lsp
        { "<leader>lD", group = "Debugging", icon = { icon = " ", color = "red" } },

        -- navigation
        { "[", group = "Prev", icon = { icon = "󰄾 ", color = "magenta" } },
        { "]", group = "Next", icon = { icon = "󰄿 ", color = "magenta" } },
        { "g", group = "Goto", icon = { icon = "󰌌 ", color = "yellow" } },
      },
    },
  },
}
