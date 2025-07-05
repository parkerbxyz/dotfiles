#
# Executes commands at the start of an interactive session.
#

export PATH="/opt/homebrew/bin:$PATH"

## Operating system-specific variables
case "$OSTYPE" in
"darwin"*) : $(brew --prefix) ;; # macOS
"linux"*) : "/usr" ;;            # Linux
*) : exit 1 ;;
esac
# Set the variable from the case statement
PREFIX="$_"

# Try to correct the spelling of commands
setopt correct

# Smartcase tab completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# zsh-syntax-highlighting (https://github.com/zsh-users/zsh-syntax-highlighting)
ZSH_SYNTAX_HIGHLIGHTING="$PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if test -f "$ZSH_SYNTAX_HIGHLIGHTING"; then
  source "$ZSH_SYNTAX_HIGHLIGHTING"
fi

# zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
ZSH_AUTOSUGGESTIONS="$PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if test -f "$ZSH_AUTOSUGGESTIONS"; then
  source "$ZSH_AUTOSUGGESTIONS"
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  ZSH_AUTOSUGGEST_HISTORY_IGNORE="git *|cd *"
fi

# Enable colorized output for `ls` command
alias ls="ls -G"

# Set default editor
export EDITOR="code --wait"

# Homebrew formulae with executables in $(brew --prefix)/sbin
#if type brew &>/dev/null; then
  export PATH="$(brew --prefix)/sbin:$PATH"
#fi

# Homebrew completions (https://docs.brew.sh/Shell-Completion)
if type brew &>/dev/null; then
  # get the Homebrew-managed zsh site-functions on FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Enable the default zsh completions
autoload -Uz compinit && compinit

# Starship (https://github.com/starship/starship)
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# 1Password CLI (https://developer.1password.com/docs/cli)
if command -v op &>/dev/null; then
  # enable shell completion
  eval "$(op completion zsh)"; compdef _op op
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/tofu tofu

complete -o nospace -C /opt/homebrew/bin/terraform terraform
