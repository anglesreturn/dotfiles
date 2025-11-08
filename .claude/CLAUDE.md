# Dotfiles Configuration

## Formatting Standards

**Lua (StyLua):**
- **120 characters** per line
- **2 spaces** indentation (never tabs)
- **Single quotes** preferred: `'string'`
- **No parentheses** for string/table args: `require 'module'`
- **Unix line endings** (LF)

**Python (Ruff):**
- **105 characters** per line
- Ignores: E701-703 (multi-statement lines), F401 (unused imports)
- Type checking via mypy/Pyright

### File Organization
```
nvim/lua/
├── options.lua              # Global settings
├── config/lazy.lua          # Plugin manager
└── plugins/                 # One domain per file
    ├── lsp.lua              # LSP config
    ├── telescope.lua        # Fuzzy finder
    ├── ai.lua               # AI tools
    └── ...                  # Each feature isolated
```

**Pattern:** Flat hierarchy, descriptive names (no abbreviations), one concern per file

### Naming Conventions
- **Files:** `lowercase-with-hyphens.lua`
- **Variables:** `snake_case` for locals: `local dap_python`
- **Functions:** Descriptive: `get_python_path()` not `get_py_path()`
- **Constants:** `UPPERCASE` or `vim.g.variable`
- **Plugins:** `'author/plugin-name'` (kebab-case)

### Common Patterns

**Plugin declaration:**
```lua
return {
  'author/plugin-name',
  dependencies = { ... },
  opts = { ... },
  keys = { ... },    -- lazy-load on keypress
  ft = { 'rust' },   -- lazy-load on filetype
}
```

**Keymap helper:**
```lua
map('<leader>lf', vim.lsp.buf.format, 'Format file')
```

**Leader namespaces:**
- `<leader>f` - Find (Telescope)
- `<leader>l` - LSP
- `<leader>d` - Database
- `<leader>g` - Git
- `<leader>c` - Code/Claude
