# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zshrc.pre.zsh"
#
# Executes commands at the start of an interactive session.
#

# Operating system-specific variables
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

# Homebrew formulae with executables in /usr/local/sbin
if type brew &>/dev/null; then
  export PATH="/usr/local/sbin:$PATH"
fi

# Homebrew completions (https://docs.brew.sh/Shell-Completion)
if type brew &>/dev/null; then
  # get the Homebrew-managed zsh site-functions on FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Enable the default zsh completions
autoload -Uz compinit && compinit

# rbenv (https://github.com/rbenv/rbenv)
if command -v rbenv &>/dev/null; then
  # load rbenv automatically
  eval "$(rbenv init -)"
fi

# pyenv (https://github.com/pyenv/pyenv)
if command -v pyenv &>/dev/null; then
  # enable shims and autocompletion
  eval "$(pyenv init -)"
  # silence pyenv brew doctor warnings
  source "$HOME/.pyenv/brew.sh"
fi

# nodenv (https://github.com/nodenv/nodenv)
if command -v nodenv &>/dev/null; then
  # load nodenv automatically
  eval "$(nodenv init -)"
fi

# Pipenv (https://github.com/pypa/pipenv)
if command -v pipenv &>/dev/null; then
  # respect pyenv’s global and local Python versions
  export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
  # enable shell completion
  eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"
fi

# Starship (https://github.com/starship/starship)
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zshrc.post.zsh"
