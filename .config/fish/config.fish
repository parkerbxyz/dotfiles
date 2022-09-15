if status is-interactive
    # Commands to run in interactive sessions
    command -q starship && starship init fish | source
    command -q nodenv && nodenv init - | source
    command -q rbenv && rbenv init - | source
    command -q pyenv && pyenv init - | source
        # Fix brew doctor's pyenv "config" scripts warning
        and alias brew="env PATH=(string replace (pyenv root)/shims '' \"\$PATH\") brew"

    # VS Code shell integration (experimental)
    # https://code.visualstudio.com/docs/terminal/shell-integration
    string match -q "$TERM_PROGRAM" "vscode"
        and . (code --locate-shell-integration-path fish)
end
