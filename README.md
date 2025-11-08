# dotfiles

Minimal, modular configuration for Neovim, tmux, and shell tools.

## setup

**clone:**
```bash
git clone https://github.com/anglesreturn/dotfiles ~/.config
```

**macOS:**
```bash
cd ~/.config
./bootstrap-macos.sh
```

**container (ubuntu/debian):**
```bash
cd ~/.config
./bootstrap-container.sh
```

## hotkeys (nvim)

leader: `space`

```
# window management
<leader>wv    Split vertical
<leader>wh    Split horizontal
<leader>wq    Close window
<leader>ww    Save file

# finding & search
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

# code actions
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

# markdown
<leader>mp    Markdown preview
<leader>ms    Stop markdown preview

# database
<leader>db    Toggle database UI
<leader>dn    Add connection
<leader>dr    Execute query

# terminal
<C-h/j/k/l>   Navigate between vim/tmux panes (works in terminal mode)
<C-\><C-n>    Exit terminal mode
<C-Tab>       Next buffer
<C-S-Tab>     Previous buffer
```
