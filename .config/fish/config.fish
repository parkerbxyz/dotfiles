if status is-interactive
    # Commands to run in interactive sessions
    command -q starship && starship init fish | source
    command -q rbenv && rbenv init - | source

    # VS Code shell integration
    # https://code.visualstudio.com/docs/terminal/shell-integration
    string match -q "$TERM_PROGRAM" "vscode"
        and . (code --locate-shell-integration-path fish)

    # 1Password CLI shell completion (https://developer.1password.com/docs/cli)
    command -q op && op completion fish | source
end

# Configure Homebrew shell environment
eval "$(/opt/homebrew/bin/brew shellenv)"
