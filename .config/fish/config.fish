if status is-interactive
    # Commands to run in interactive sessions can go here
    command -q starship && starship init fish | source
    command -q rbenv && rbenv init - | source
    command -q pyenv && pyenv init - | source
end
