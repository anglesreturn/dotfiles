set -e

echo "Setting up dotfiles for container environment..."

if ! command -v apt-get &>/dev/null; then
  echo "Error: apt-get not found. This script requires Ubuntu/Debian."
  exit 1
fi

echo "Updating package lists..."
sudo apt-get update

echo "Installing system dependencies..."
sudo apt-get install -y \
  build-essential \
  curl \
  git \
  wget \
  unzip \
  ripgrep \
  fd-find \
  jq \
  python3 \
  python3-pip \
  python3-venv \
  nodejs \
  npm \
  luarocks

echo "Installing Neovim..."
if ! command -v nvim &>/dev/null; then
  wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
  rm nvim-linux64.tar.gz
fi

echo "Installing Rust toolchain..."
if ! command -v rustc &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

echo "Installing formatters..."
cargo install stylua
wget -qO- https://github.com/mvdan/sh/releases/latest/download/shfmt_linux_amd64 >/tmp/shfmt
sudo install /tmp/shfmt /usr/local/bin/shfmt
cargo install taplo-cli --locked

echo "Installing Python tools..."
pip3 install --upgrade pip
pip3 install ruff mypy

echo "Setting up tmux plugin manager..."
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi
~/.config/tmux/plugins/tpm/bin/install_plugins

echo "Setting up Neovim..."
nvim --headless "+Lazy! sync" +qa

echo "Container setup complete."
echo ""
echo "Next steps:"
echo "  1. Reload shell: source ~/.bashrc (or ~/.zshrc)"
echo "  2. Run: nvim"
echo "  3. Check health: :checkhealth"
