# Initialization code sourced at every fish shell (interactive or non-interactive).

# Environment variables.
set -x SSH_AUTH_SOCK $HOME/.1password/agent.sock

set -x EDITOR nvim
set -x VISUAL code
set -x BROWSER firefox

set -x NIXOS_CONFIG $HOME/.nixos-config
set -x DOTFILES $HOME/.dotfiles
