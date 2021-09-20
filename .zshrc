#
# Executes commands at the start of an interactive session.
#

# operating system-specific variables
case "$OSTYPE" in
"darwin"*) # macOS
  ZSH_SYNTAX_HIGHLIGHTING="usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  ZSH_AUTOSUGGESTIONS="usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ;;
"linux"*) # Linux
  ZSH_SYNTAX_HIGHLIGHTING="usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  ZSH_AUTOSUGGESTIONS="usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ;;
esac

# try to correct the spelling of commands
setopt correct

# smartcase tab completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# zsh-syntax-highlighting (https://github.com/zsh-users/zsh-syntax-highlighting)
if test -f "$ZSH_SYNTAX_HIGHLIGHTING"; then
  source "$ZSH_SYNTAX_HIGHLIGHTING"
fi

# zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
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
export PATH="/usr/local/sbin:$PATH"

# Homebrew completions (https://docs.brew.sh/Shell-Completion)
if type brew &>/dev/null; then
  # get the Homebrew-managed zsh site-functions on FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Enable the default zsh completions
autoload -Uz compinit && compinit

# octo-cli (https://github.com/octo-cli/octo-cli)
if command -v octo &>/dev/null; then
  # enable shell completion
  eval "$(octo --install-completions)"
fi

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
  eval "$(pipenv --completion)"
fi

# Added by github/training-manual class setup
test -f "$HOME/.trainingmanualrc" && source "$HOME/.trainingmanualrc"

# starship (https://github.com/starship/starship)
eval "$(starship init zsh)"
