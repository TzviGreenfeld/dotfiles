# ──────────────────────────────────────────────────────────────
# Powerlevel10k Instant Prompt (keep at top for fast shell start)
# ──────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ──────────────────────────────────────────────────────────────
# Paths
# ──────────────────────────────────────────────────────────────
# Add custom development folder to PATH
file

# ──────────────────────────────────────────────────────────────
# Oh My Zsh + Theme
# ──────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ──────────────────────────────────────────────────────────────
# Plugins
# ──────────────────────────────────────────────────────────────
plugins=(
  git
  zsh-autosuggestions
  zsh-history-substring-search
)
source "$ZSH/oh-my-zsh.sh"

# Additional plugin sources
source "$ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH/zsh-history-substring-search/zsh-history-substring-search.zsh"

# ──────────────────────────────────────────────────────────────
# Keybindings
# ──────────────────────────────────────────────────────────────
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# ──────────────────────────────────────────────────────────────
# Powerlevel10k Config
# ──────────────────────────────────────────────────────────────
[[ -f "$ZSH/.p10k.zsh" ]] && source "$ZSH/.p10k.zsh"
