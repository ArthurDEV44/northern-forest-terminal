# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt AUTO_CD

# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Plugins ---
# Linux (Fedora/Debian)
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# macOS (Homebrew — Apple Silicon or Intel)
elif [[ -f ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source ${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- Northern Forest - Plugin colors ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#3a4f4a"
ZSH_HIGHLIGHT_STYLES[default]="fg=#c5d1cc"
ZSH_HIGHLIGHT_STYLES[command]="fg=#56d6b6,bold"
ZSH_HIGHLIGHT_STYLES[alias]="fg=#56d6b6,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=#4dc4b0,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=#56b68a"
ZSH_HIGHLIGHT_STYLES[path]="fg=#5b8fb4,underline"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=#d4a35c"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#7ddba8"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#7ddba8"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=#6b8580"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=#d4a35c"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#d4555e"

# --- Key bindings ---
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# --- Path ---
export PATH="$HOME/.local/bin:$PATH"

# --- Aliases ---
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'
alias cc='claude'
alias cct='tmux new-session -s claude-team "claude"'

# --- Starship ---
eval "$(starship init zsh)"

# --- Custom Launch Terminal ---
fastfetch

# bun completions
[ -s "/home/arthur/.bun/_bun" ] && source "/home/arthur/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
