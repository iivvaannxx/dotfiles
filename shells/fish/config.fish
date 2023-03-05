# Only execute this file once per shell.
set -q __fish_config_sourced; and exit
set -g __fish_config_sourced 1

# The path where all the files are located.
dotfilesPath = "$HOME/.dotfiles/shells/fish"
runCommandsPath = "$dotfilesPath/run-commands"

# Sourced for the interactive shells.
status --is-interactive; and begin

    source "$runCommandsPath/interactive-shell-rc.fish"

    # Is starship installed?
    if type -q starship

        # Initialize starship.
        starship init fish | source
    end
end

# Sourced for the login shells.
status --is-login; and begin
    source "$runCommandsPath/login-shell-rc.fish"
end

# Sourced for all the shells.
source "$runCommandsPath/shell-rc.fish"

