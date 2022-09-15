if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    source (rbenv init - | psub)
    source (pyenv init - | psub)
end
