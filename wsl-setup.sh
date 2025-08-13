#!/usr/bin/env bash
set -e

echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y git curl wget zsh unzip fonts-powerline

# ──────────────────────────────────────────────
# Install Oh My Zsh
# ──────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💡 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh already installed."
fi

# ──────────────────────────────────────────────
# Install Powerlevel10k
# ──────────────────────────────────────────────
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "💡 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "✅ Powerlevel10k already installed."
fi

# ──────────────────────────────────────────────
# Install Zsh plugins
# ──────────────────────────────────────────────
plugins=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-history-substring-search"
)

for plugin in "${plugins[@]}"; do
    name=$(basename "$plugin")
    dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"
    if [ ! -d "$dest" ]; then
        echo "💡 Installing plugin: $name"
        git clone https://github.com/$plugin "$dest"
    else
        echo "✅ Plugin $name already installed."
    fi
done

# ──────────────────────────────────────────────
# Install Meslo Nerd Fonts (for Powerlevel10k)
# ──────────────────────────────────────────────
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

fonts=(
    "MesloLGS NF Regular.ttf"
    "MesloLGS NF Bold.ttf"
    "MesloLGS NF Italic.ttf"
    "MesloLGS NF Bold Italic.ttf"
)

base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"

for font in "${fonts[@]}"; do
    if [ ! -f "$FONT_DIR/$font" ]; then
        echo "💡 Installing font: $font"
        wget -qO "$FONT_DIR/$font" "$base_url/${font// /%20}"
    else
        echo "✅ Font $font already installed."
    fi
done

echo "🔄 Updating font cache..."
fc-cache -fv

echo "🎉 Setup complete! Open a new terminal and run:"
echo "   p10k configure"


chsh -s $(which zsh)
wsl --shutdown
