set -e

echo "Setting up dotfiles for macOS..."

if ! command -v brew &>/dev/null; then
  echo "Error: Homebrew not found. Install from https://brew.sh"
  exit 1
fi

echo "Ensuring Xcode Command Line Tools (needed for tree-sitter)..."
xcode-select -p &>/dev/null || xcode-select --install

echo "Installing core tools..."
brew install \
  neovim \
  git \
  tmux \
  ripgrep \
  fd \
  jq \
  node \
  python@3.12 \
  luarocks

echo "Installing fonts..."
brew install --cask font-meslo-lg-nerd-font

echo "Installing formatters..."
brew install stylua shfmt taplo

echo "Installing Python tools..."
pip3 install --upgrade pip
pip3 install ruff mypy

echo "Setting up tmux plugin manager..."
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi
~/.config/tmux/plugins/tpm/bin/install_plugins

echo "Configuring iTerm2 font..."
if [ -f "$HOME/Library/Preferences/com.googlecode.iterm2.plist" ]; then
  /usr/libexec/PlistBuddy -c "Set ':New Bookmarks:0:Normal Font' 'MesloLGS-NF-Regular 13'" \
    "$HOME/Library/Preferences/com.googlecode.iterm2.plist" 2>/dev/null || true
fi

echo "Setting up Neovim..."
nvim --headless "+Lazy! sync" +qa

echo "macOS setup complete."
echo ""
echo "Next steps:"
echo "  1. Run: nvim"
echo "  2. Authenticate Codeium: :Codeium Auth"
echo "  3. Check health: :checkhealth"
