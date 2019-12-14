#
# Executes commands at the start of an interactive session.
#

# enable the default zsh completions
autoload -Uz compinit && compinit

# zsh-syntax-highlighting (https://github.com/zsh-users/zsh-syntax-highlighting)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# thefuck (https://github.com/nvbn/thefuck)
eval $(thefuck --alias oops)

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
fi

# Pipenv (https://github.com/pypa/pipenv)
if command -v pipenv 1>/dev/null 2>&1; then
  # respect pyenv’s global and local Python versions
  export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
  # enable shell completion
  eval "$(pipenv --completion)"
fi

# added by github/training-manual class setup
test -f "~/.trainingmanualrc" && source "~/.trainingmanualrc"

# starship (https://github.com/starship/starship)
eval "$(starship init zsh)"
