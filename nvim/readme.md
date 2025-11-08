# Neovim Configuration

Lua-based Neovim config with LSP, debugging, AI completions, and modern tooling.

## Requirements

- Neovim 0.10.1+
- Node.js (for Codeium)
- make, cargo (for building plugins)
- Formatters: stylua, rustfmt, ruff, jq, shfmt, taplo
- Linters: mypy
- Claude Code CLI (for claude-code.nvim integration)

## Setup

**1. Install dependencies:**
```bash
# Formatters
cargo install stylua
brew install rustfmt jq shfmt
pip install ruff mypy

# Claude Code CLI
# Follow installation at: https://github.com/anthropics/claude-code
```

**2. Authenticate Codeium:**
```vim
:Codeium Auth
```

**3. Restart Neovim**

Lazy.nvim will auto-install plugins on first launch.

## Keybindings

Leader key: `Space`

```lua
-- GENERAL
<Esc>              -- Clear search highlighting
<leader>wv         -- Window: vertical split
<leader>wh         -- Window: horizontal split
<leader>wq         -- Window: quit
<leader>ww         -- Window: write (save)

-- TELESCOPE (FUZZY FINDER)
/                  -- Find in current buffer
<leader><leader>   -- Find existing buffers
<leader>fo         -- Find recent files (oldfiles)
<leader>fc         -- Find config files (in ~/.config/nvim)
<leader>ff         -- Find files (root directory)
<leader>fF         -- Find files (current working directory)
<leader>fh         -- Find files (home directory)
<leader>fg         -- Find in project (live grep)
<leader>fG         -- Find in open files (grep)
<leader>fk         -- Find keymaps
<leader>fw         -- Find current word under cursor
<leader>fd         -- Find diagnostics
<leader>fr         -- Find LSP references
<leader>sr         -- Search and replace in current file

-- LSP
K                  -- Show hover information
<leader>ld         -- Go to definition
<leader>lr         -- Rename symbol
<leader>lI         -- Go to implementation
<leader>ls         -- Show function signature help
<leader>ca         -- Code action (normal & visual mode)
<leader>lc         -- Go to declaration
<leader>lf         -- Format buffer or selection (normal & visual mode)
<leader>li         -- Organize imports

-- DEBUGGING (DAP)
<leader>lDs        -- Start/Continue debugging
<leader>lDo        -- Step over
<leader>lDi        -- Step into
<leader>lDO        -- Step out
<leader>lDb        -- Toggle breakpoint
<leader>lDB        -- Set conditional breakpoint
<leader>lDL        -- Set log point

-- DATABASE (vim-dadbod)
<leader>db         -- Toggle database UI
<leader>dn         -- Add new connection
<leader>dr         -- Execute query
<leader>df         -- Find buffer
<leader>dh         -- Show help

-- AI (CODEIUM)
<Tab>              -- Accept Codeium completion
<M-]>              -- Next Codeium suggestion (Alt+])
<M-[>              -- Previous Codeium suggestion (Alt+[)
<C-]>              -- Clear Codeium suggestion (Ctrl+])

-- TERMINAL
<C-\><C-n>         -- Exit terminal mode
<C-h/j/k/l>        -- Navigate between windows (terminal mode)
<C-Tab>            -- Next buffer
<C-S-Tab>          -- Previous buffer

-- UTILITIES
<leader>cs         -- Split comma-separated values (visual mode)

-- CLAUDE CODE
<leader>cc         -- Toggle Claude Code terminal
                   -- (Auto-refreshes files modified by Claude)

-- RUST (rustaceanvim)
<leader>le         -- Expand Rust macro
<leader>lm         -- Rust hover actions
<leader>lt         -- Run Rust tests

-- COMPLETION (blink.cmp)
<Tab>/<S-Tab>      -- Navigate completion menu (super-tab preset)
<CR>               -- Confirm completion
```

## Plugin Overview

**LSP:**
- pyright (Python)
- ruff (Python linting/formatting)
- lua_ls (Lua)
- jsonls (JSON with schemastore)
- bashls (Bash)
- rust-analyzer (Rust via rustaceanvim)

**Completion:**
- blink.cmp (fast completion engine)
- codeium (AI-powered cursor-style completions)

**AI:**
- codeium.nvim (inline AI completions, free)
- claude-code.nvim (Claude Code CLI integration)

**Formatting:**
- conform.nvim (format on save)
- Configured: stylua, rustfmt, ruff, jq, shfmt, taplo

**Linting:**
- nvim-lint (mypy for Python)

**UI:**
- lualine (statusline)
- kanagawa (colorscheme)
- mini.nvim (indentscope, pairs, surround)

**Tools:**
- telescope.nvim (fuzzy finder)
- nvim-treesitter (syntax highlighting)
- vim-dadbod (database interface)
- nvim-dap (debugging for Python)
- markdown-preview.nvim (live markdown preview)

## File Structure

```
~/.config/nvim/
├── init.lua                      # Entry point
├── lua/
│   ├── options.lua               # Editor options
│   ├── keymaps.lua               # Core keybindings
│   ├── config/
│   │   └── lazy.lua              # Plugin manager setup
│   └── plugins/
│       ├── ai.lua                # AI plugins (Codeium, Claude Code)
│       ├── lsp.lua               # LSP configuration
│       ├── telescope.lua         # Fuzzy finder
│       ├── treesitter.lua        # Syntax highlighting
│       ├── ui.lua                # UI plugins
│       ├── debug.lua             # DAP debugging
│       ├── database.lua          # Database tools
│       └── markdown.lua          # Markdown preview
└── .ruff.toml                    # Ruff Python config (moved to ~/.config/ruff/)
```

## Configuration Notes

**Python:**
- Ruff handles both linting and formatting
- Mypy for type checking
- Pyright for LSP with diagnostics disabled (Ruff handles that)
- Config: `~/.config/ruff/ruff.toml` (line-length: 105)

**Rust:**
- rustaceanvim provides rust-analyzer integration
- Clippy on save with custom rules
- rustfmt formatting

**Format on Save:**
- Enabled globally (timeout: 500ms)
- Uses LSP fallback for unsupported file types
- Rust uses rustfmt directly (not LSP)

**Codeium:**
- Free AI completions
- Virtual text enabled (shows inline like Cursor)
- Integrated with blink.cmp
- Requires `:Codeium Auth` on first use

**Claude Code:**
- Opens Claude Code CLI in right split (80 cols)
- Auto-refreshes files modified by Claude
- 500ms debounce on file changes
