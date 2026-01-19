-- for highlight plugin
vim.opt.termguicolors = true
vim.opt.encoding = 'utf-8'

-- Set indentation rules for Lua files
vim.opt.tabstop = 2 -- Number of spaces for a tab
vim.opt.shiftwidth = 2 -- Number of spaces for auto-indent
vim.opt.softtabstop = 2 -- Number of spaces for <Tab> in insert mode
vim.opt.expandtab = true -- Use spaces instead of tabs

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

-- Rounded borders for floating windows
vim.opt.winborder = 'rounded'

-- Auto-commands
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'lua', 'javascript', 'typescript' },
  callback = function()
    vim.keymap.set('v', '<leader>cs', function()
      local start_line = vim.fn.line 'v'
      local end_line = vim.fn.line '.'
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end

      for line = start_line, end_line do
        local content = vim.fn.getline(line)
        local new_content = content:gsub(',', ',\n')
        vim.fn.setline(line, vim.split(new_content, '\n'))
      end
    end, { buffer = true, desc = 'Split comma-separated values' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'lua', 'javascript', 'typescript' },
  callback = function()
    vim.api.nvim_create_autocmd('TextChanged', {
      buffer = 0,
      callback = function()
        local line_num = vim.fn.line '.'
        local line = vim.fn.getline(line_num)
        local comment_char = vim.bo.commentstring:match '^(.*)%%s'

        if comment_char and line:match('^%s*' .. vim.pesc(comment_char)) and #line > 120 then
          local indent = line:match '^(%s*)'
          local comment_text = line:gsub('^%s*' .. vim.pesc(comment_char) .. '%s*', '')

          local words = {}
          for word in comment_text:gmatch '%S+' do
            table.insert(words, word)
          end

          local lines = {}
          local current_line = ''
          for _, word in ipairs(words) do
            if #(current_line .. ' ' .. word) + #indent + #comment_char > 120 then
              table.insert(lines, indent .. comment_char .. ' ' .. current_line)
              current_line = word
            else
              current_line = current_line == '' and word or current_line .. ' ' .. word
            end
          end
          if current_line ~= '' then table.insert(lines, indent .. comment_char .. ' ' .. current_line) end

          if #lines > 1 then
            vim.fn.setline(line_num, lines[1])
            for i = 2, #lines do
              vim.fn.append(line_num + i - 2, lines[i])
            end
          end
        end
      end,
    })
  end,
})
