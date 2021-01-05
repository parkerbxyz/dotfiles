#
# Executes commands at the start of an interactive session.
#

# try to correct the spelling of commands
setopt correct

# smartcase tab completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# enable the default zsh completions
autoload -Uz compinit && compinit

# zsh-syntax-highlighting (https://github.com/zsh-users/zsh-syntax-highlighting)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE="git *|cd *"

# Enable colorized output for `ls` command
alias ls="ls -G"

# thefuck (https://github.com/nvbn/thefuck)
eval "$(thefuck --alias oops)"

# rbenv (https://github.com/rbenv/rbenv)
if command -v rbenv 1>/dev/null 2>&1; then
  # load rbenv automatically
  eval "$(rbenv init -)"
fi

# pyenv (https://github.com/pyenv/pyenv)
if command -v pyenv 1>/dev/null 2>&1; then
  # define environment variable
  export PYENV_ROOT="$HOME/.pyenv"
  # enable shims and autocompletion
  eval "$(pyenv init -)"
  # silence pyenv brew doctor warnings
  source "$HOME/.pyenv/brew.sh"
fi

# nodenv (https://github.com/nodenv/nodenv)
if command -v nodenv 1>/dev/null 2>&1; then
  # load nodenv automatically
  eval "$(nodenv init -)"
fi

# Pipenv (https://github.com/pypa/pipenv)
if command -v pipenv 1>/dev/null 2>&1; then
  # respect pyenv’s global and local Python versions
  export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
  # enable shell completion
  eval "$(pipenv --completion)"
fi

# octo-cli (https://github.com/octo-cli/octo-cli)
if command -v octo 1>/dev/null 2>&1; then
  # enable shell completion
  eval "$(octo --install-completions)"
fi

# added by github/training-manual class setup
test -f "$HOME/.trainingmanualrc" && source "$HOME/.trainingmanualrc"

# starship (https://github.com/starship/starship)
export STARSHIP_CONFIG=$HOME/.starship
eval "$(starship init zsh)"
