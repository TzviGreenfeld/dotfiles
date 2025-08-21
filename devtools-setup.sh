#!/bin/bash

# Pop!_OS Development Environment Setup Script
# Run with: bash setup.sh

set -e  # Exit on any error

echo "🚀 Setting up your Pop!_OS development environment..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "🔧 Installing essential packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    neovim \
    htop \
    tree \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev

# Install Docker
echo "🐳 Installing Docker..."
# Remove old versions if they exist
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

echo "✅ Docker installed successfully!"

# Install Python and uv
echo "🐍 Installing Python and uv..."
# Python should already be installed on Pop!_OS, but let's ensure we have python3-pip
sudo apt install -y python3 python3-pip python3-venv python3-dev

# Install uv (modern Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.cargo/env 2>/dev/null || true

echo "✅ Python and uv installed successfully!"

# Install Zsh and Oh My Zsh
echo "🐚 Installing Zsh and Oh My Zsh..."
sudo apt install -y zsh

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install useful Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true

# Update .zshrc with useful plugins
if [ -f "$HOME/.zshrc" ]; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker python)/' $HOME/.zshrc
fi

# Set Zsh as default shell
sudo chsh -s $(which zsh) $USER

echo "✅ Zsh installed and configured successfully!"

# Install Google Chrome
echo "🌐 Installing Google Chrome..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install -y google-chrome-stable

echo "✅ Google Chrome installed successfully!"

# Additional useful development tools
echo "🛠️  Installing additional development tools..."

# Node.js and npm (via NodeSource)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# Flatpak applications
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install some useful Flatpak apps
# flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub com.spotify.Client
# flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub com.discordapp.Discord

# Install Rust (useful for many modern tools)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Install modern CLI tools
cargo install exa bat fd-find ripgrep
sudo apt install -y fzf

# Terminal emulator (Alacritty - fast, modern terminal)
cargo install alacritty

# Font for development (FiraCode with ligatures)
sudo apt install -y fonts-firacode

echo "✅ Additional tools installed successfully!"

# Configure Git (optional - user can set this later)
echo "📝 Git configuration (you can skip this and configure later)..."
read -p "Enter your Git username (or press Enter to skip): " git_username
read -p "Enter your Git email (or press Enter to skip): " git_email

if [ ! -z "$git_username" ]; then
    git config --global user.name "$git_username"
fi

if [ ! -z "$git_email" ]; then
    git config --global user.email "$git_email"
fi

# Create useful aliases
echo "⚡ Setting up useful aliases..."
cat >> $HOME/.zshrc << 'EOF'

# Custom aliases
alias ll='exa -la'
alias la='exa -la'
alias ls='exa'
alias cat='bat'
alias find='fd'
alias grep='rg'
alias docker-clean='docker system prune -af'
alias python='python3'
alias pip='pip3'

# Docker aliases
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

EOF

echo "🎉 Setup complete!"
echo ""
echo "📋 What was installed:"
echo "  ✅ Docker (with docker-compose)"
echo "  ✅ Python 3 + uv package manager"
echo "  ✅ Zsh + Oh My Zsh (with useful plugins)"
echo "  ✅ Google Chrome"
echo "  ✅ VS Code"
echo "  ✅ Node.js + npm"
echo "  ✅ Rust + Cargo"
echo "  ✅ Modern CLI tools (exa, bat, fd, ripgrep, fzf)"
echo "  ✅ Alacritty terminal"
echo "  ✅ FiraCode font"
echo "  ✅ Flatpak apps (Firefox, Spotify, Telegram, Discord)"
echo ""
echo "🔄 Please log out and log back in (or restart) to:"
echo "  - Use Zsh as your default shell"
echo "  - Use Docker without sudo"
echo "  - Load all new environment variables"
echo ""
echo "💡 After reboot, try these commands to test:"
echo "  docker --version"
echo "  python3 --version"
echo "  uv --version"
echo "  code --version"
echo "  google-chrome --version"
