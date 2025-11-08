# Dotfiles

Minimal, modular configuration for Neovim, tmux, and shell tools.

## Quick Setup

**Clone:**
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles ~/.config
```

**macOS:**
```bash
cd ~/.config
./bootstrap-macos.sh
```

**Container (Ubuntu/Debian):**
```bash
cd ~/.config
./bootstrap-container.sh
```

## Leader Keys (Neovim)

Leader: `Space`

### Window Management
```
<leader>wv    Split vertical
<leader>wh    Split horizontal
<leader>wq    Close window
<leader>ww    Save file
```

### Finding & Search
```
<leader>ff    Find files (project root)
<leader>fF    Find files (current directory)
<leader>fh    Find files (home directory)
<leader>fg    Find in project (grep)
<leader>fG    Find in open files
<leader>fw    Find current word
<leader>fo    Find recent files
<leader>fc    Find config files
<leader>fd    Find diagnostics
<leader>fr    Find LSP references
<leader><leader>  Switch buffers
/             Search in current file
<leader>sr    Find and replace in current file
```

### Code Actions
```
<leader>ca    Code actions
<leader>lf    Format file or selection (works in visual mode)
<leader>li    Organize imports
<leader>ld    Go to definition
<leader>lr    Rename symbol
<leader>lI    Go to implementation
<leader>ls    Show signature help
<leader>lc    Go to declaration
<leader>cs    Split comma-separated values (visual mode)
K             Show hover info
```

### Markdown
```
<leader>mp    Markdown preview
<leader>ms    Stop markdown preview
```

### Database
```
<leader>db    Toggle database UI
<leader>dn    Add connection
<leader>dr    Execute query
```

### Terminal
```
<C-h/j/k/l>   Navigate between vim/tmux panes (works in terminal mode)
<C-\><C-n>    Exit terminal mode
<C-Tab>       Next buffer
<C-S-Tab>     Previous buffer
```

## Tool-Specific Docs

- [Neovim](nvim/readme.md) - LSP, formatters, keybindings
- [tmux](tmux/tmux.conf) - Terminal multiplexer config
- [VSCode](vscode/README.md) - Extensions and settings

## Requirements

**macOS:** Homebrew

**Container:** Ubuntu 20.04+ or Debian 11+

**Neovim:** 0.10.1+

**Formatters:** stylua, rustfmt, ruff, jq, shfmt, taplo

**Linters:** mypy

## Common Commands

**Neovim:**
```bash
nvim                 # Launch with lazy.nvim auto-install
:Lazy sync          # Update plugins
:Mason              # Manage LSP servers
:checkhealth        # Verify setup
```

**Git:**
```bash
git add -u          # Stage tracked changes
git commit          # Commit (write message in editor)
git log --oneline   # View recent commits
```
