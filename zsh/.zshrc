# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gustavo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Avoid duplicates
setopt HIST_IGNORE_DUPS       # skip duplicate commands
setopt HIST_IGNORE_SPACE      # skip commands that start with space
setopt SHARE_HISTORY          # share history between terminals
setopt INC_APPEND_HISTORY     # append commands to history immediately

# Zsh autosuggestions
#source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'   # gray color

alias nixedit='codium /etc/nixos && exit'
alias hypredit='codium .config/hypr && exit'
alias zshedit='codium ~/.zshrc && exit' 

alias nixos-clean="sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage"
alias hm-clean="home-manager expire-generations +5 && nix-collect-garbage"



# Run FastFetch automatically when opening a terminal
# Run fastfetch only for interactive shells
if [[ -o interactive ]]; then
  fastfetch </dev/null
fi


# Word navigation (bash-like)
bindkey '^[b' backward-word
bindkey '^[f' forward-word


# --- FZF setup for NixOS ---
export FZF_DEFAULT_OPTS="--height 40% --border --reverse"

# Source the key bindings directly
if [ -f /nix/store/bw12xvv5brgqz5j1nm58jhfyxsqyi7sz-fzf-0.67.0/share/fzf/key-bindings.zsh ]; then
    source /nix/store/bw12xvv5brgqz5j1nm58jhfyxsqyi7sz-fzf-0.67.0/share/fzf/key-bindings.zsh
fi

# Optional: Ctrl+T previews for files (install bat for preview)
# Ctrl+T uses only the current folder (ls) instead of recursive find
export FZF_CTRL_T_COMMAND='ls -A'   # -A hides . and .., shows all other files

export EDITOR="codium --wait"
export VISUAL="codium --wait"

# Optional: Alt+C previews for directories
export FZF_ALT_C_COMMAND='ls -d */ 2>/dev/null'  # list only directories

#export PATH="$HOME/.local/bin:$PATH"

# Não perguntar sobre jobs em background ao fechar o shell
setopt no_hup
setopt no_nomatch
unsetopt monitor

