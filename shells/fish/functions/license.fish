function license

    function print_help
        echo -e '  Usage: license <license>'
        echo -e '  Available licenses: \n'

        for license in $argv
            echo -e '    - ' $license
        end

        echo -ne '\n'
    end

    echo -ne '\n'
    set -l licenses (curl -sL 'https://api.github.com/licenses' | jq -r '.[].key')

    if test (count $argv) -gt 1

        echo -e "  Error: Too many arguments\n"
        print_help $licenses

        return 1

    else if test -z $argv || test $argv = -h || test $argv = --help

        print_help $licenses
        return 0

    else if test (count $argv) -eq 1 && contains $argv $licenses

        curl -sL https://api.github.com/licenses/$argv | jq -r '.body' | bat -l md

        echo -ne '\n'
        return 0

    else

        echo -e "  Error: Invalid license '$argv'\n"

        print_help $licenses
        return 1

    end
end
