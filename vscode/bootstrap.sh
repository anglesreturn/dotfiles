set -e

DOT="$HOME/.config/vscode"
DEST="$HOME/Library/Application Support/Code/User" # adjust for your OS if needed

mkdir -p "$DEST"
ln -sf "$DOT/settings.json" "$DEST/settings.json"
ln -sf "$DOT/keybindings.json" "$DEST/keybindings.json"
ln -sf "$DOT/snippets" "$DEST/snippets"

# install extensions
while read -r ext; do
  code --install-extension "$ext" || true
done <"$DOT/extensions.list"
