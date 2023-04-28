if status is-interactive
    # Commands to run in interactive sessions
    command -q starship && starship init fish | source
    command -q nodenv && nodenv init - | source
    command -q rbenv && rbenv init - | source
    command -q pyenv && pyenv init - | source
    command -q thefuck && thefuck --alias oops | source

    # VS Code shell integration (experimental)
    # https://code.visualstudio.com/docs/terminal/shell-integration
    string match -q "$TERM_PROGRAM" "vscode"
        and . (code --locate-shell-integration-path fish)

    # 1Password CLI shell completion (https://developer.1password.com/docs/cli)
    command -q op && op completion fish | source
end
