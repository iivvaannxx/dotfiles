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