# Initialization code sourced at every interactive fish shell (usually on terminals).

# Remap the bindings for the fzf fish plugin.
if type -q fzf_configure_bindings
    fzf_configure_bindings --history=\e\ch --variables=\e\cv
end

# Disable the greeting.
set fish_greeting ""

status --is-interactive; and begin

    set abbreviations $HOME/.dotfiles/shells/fish/manifests/abbreviations.json

    if test -f "$abbreviations"

        for abbrev in (jq -r 'to_entries[] | "\(.key) \"\(.value)\""' "$abbreviations")

            set -l key (echo $abbrev | cut -d' ' -f1)
            set -l value (echo $abbrev | cut -d' ' -f2-)

            abbr --add --global $key $value
        end

    end

end
