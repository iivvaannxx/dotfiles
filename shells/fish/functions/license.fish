#!/usr/bin/env fish

function license

    # Prints the help message.
    function print_help

        echo -e '\tUsage: license <license>'
        echo -e '\tAvailable licenses: \n'

        for license in $argv
            echo -e '\t  - ' $license
        end
    end

    tabs 4
    echo -ne '\n'

    if not type -q jq

        echo -e "\t'jq' is required to parse JSON output. Please install it first."
        return 1
    end

    # Get the list of available licenses.
    set -l licenses (curl -sL 'https://api.github.com/licenses' | jq -r '.[].key')

    # The function only allows one argument.
    if test (count $argv) -gt 1

        echo -e "\tError: Too many arguments\n"
        print_help $licenses

        return 1

    # If no argument is given or the argument is -h or --help, print the help message.
    else if test -z $argv || test $argv = -h || test $argv = --help

        print_help $licenses
        return 0

    # Otherwise check if the argument is a valid license.
    else if test (count $argv) -eq 1 && contains (string lower $argv) $licenses

        set -l key (string lower $argv)
        echo -ne "\tGetting license '$key'..."

        # Get the license text.
        set -l license (curl -sL https://api.github.com/licenses/$key | jq -r '.body' | string join "\n")

        # If bat is installed, use it to beautifully print the result.
        if type -q bat

            echo -ne "\n"
            echo -e $license | bat -l md

        # Otherwise just print the result.
        else
            echo -e "\n\n$license"
        end
        
        return 0

    else

        echo -e "\tError: Invalid license '$argv'\n"

        print_help $licenses
        return 1

    end
end
