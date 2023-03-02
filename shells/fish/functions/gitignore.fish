function gitignore

    function echoerr
        echo 1>&2 $argv
    end

    function print_help

        echo -e "Usage: gitignore [OPTIONS] <template-1> ... <template-n>"
        echo -e "\n\tOptions:\n"

        echo -e (string pad -r -c " " -w 35 "\t\t-h, --help") "Print this help message."
        echo -e (string pad -r -c " " -w 35 "\t\t-l, --list") "List all available templates (for the given source).\n"
        echo -e (string pad -r -c " " -w 35 "\t\t-o, --output <file_name>") "Specify the output file. If not specified, the output will be printed to stdout."
        echo -e (string pad -r -c " " -w 35 "\t\t-s, --source <source_name>") "Specify the source of the templates. Refer to the 'Available Sources' section below."

        echo -e "\n\tAvailable Sources:\n"
        echo -e "\t\t- ag (api.github)"
        echo -e "\t\t- gi (gitignore.io) [default]"

        echo -e "\n\tMultiple templates can be specified (space separated). The outputs will get combined."
    end


    tabs 4
    echo -ne "\n\t"

    # No arguments were given.
    if test (count $argv) -eq 0

        print_help
        return 1
    end

    # Parse arguments.
    argparse -n "[error] gitignore" -s \
        -x output,o \
        -x list,l \
        -x help,h \
        -x list,l,output,o,help,h \
        -x source,s \
        -x source,s,help,h \
        "h/help" "l/list" "o/output=" "s/source=" \
    -- $argv


    # If the variable _flag_help or _flag_h is defined, print the help message and exit.
    if test -n "$_flag_help" || test -n "$_flag_h"

        print_help
        return 0
    end

    if test -n "$_flag_source" || test -n "$_flag_s"

        if test "$_flag_source" = "ag" || test "$_flag_s" = "ag"

            set -l template_source "ag"

        else if test "$_flag_source" = "gi" || test "$_flag_s" = "gi"

            set -l template_source"gi"

        else

            echoerr "Invalid source '$_flag_source' or '$_flag_s'."
            return 1
        end
    end

    echo $template_source


end

