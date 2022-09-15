if status is-interactive
    # Commands to run in interactive sessions can go here
    command -q starship && starship init fish | source
    command -q rbenv && rbenv init - | source
    command -q pyenv && pyenv init - | source
        # Fix brew doctor's pyenv "config" scripts warning
        and alias brew="env PATH=(string replace (pyenv root)/shims '' \"\$PATH\") brew"
end
