# Remap the bindings for the fzf fish plugin.
if type -q fzf_configure_bindings
    fzf_configure_bindings --history=\e\ch --variables=\e\cv
end

# Disable the greeting.
set fish_greeting ""
set abbreviations $HOME/.dotfiles/shells/fish/manifests/abbreviations.json

# Abbreviations are loaded by default. Set the DO_NOT_LOAD_ABBREVIATIONS environment variable to disable this behaviour.
if test -f "$abbreviations" and type -q jq and not $DO_NOT_LOAD_ABBREVIATIONS

    for abbrev in (jq -r 'to_entries[] | "\(.key) \(.value)"' "$abbreviations")

        set -l key (echo $abbrev | cut -d' ' -f1)
        set -l value (echo $abbrev | cut -d' ' -f2-)

        if not abbr -q $key
            abbr --add --global $key $value
        end
    end

end
