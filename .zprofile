# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zprofile.pre.zsh"
# pyenv (https://github.com/pyenv/pyenv)
if command -v pyenv &>/dev/null; then
  # Add pyenv executable to PATH and enable shims
  eval "$(pyenv init --path)"
fi

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zprofile.post.zsh"
