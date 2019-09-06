# Aliases
eval $(thefuck --alias)
eval $(thefuck --alias wtf)

# pyenv (https://github.com/pyenv/pyenv)
if command -v pyenv 1>/dev/null 2>&1; then # if pyenv is installed
  export PYENV_ROOT="$HOME/.pyenv" # define environment variable
  eval "$(pyenv init -)" # enable shims and autocompletion
fi

# Pipenv (https://github.com/pypa/pipenv)
if command -v pyenv 1>/dev/null 2>&1; then # if Pipenv is installed
  export PIPENV_PYTHON="$PYENV_ROOT/shims/python" # respect pyenv’s global and local Python versions
  eval "$(pipenv --completion)" # enable shell completion
fi
