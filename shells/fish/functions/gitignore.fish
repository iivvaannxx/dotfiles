function gitignore

    # Prints the given message to stderr.
    function echoerr
        echo -e 1>&2 $argv
    end


    # Prints the help message.
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


    # Prints the list of available templates for the given source.
    function print_list 

        set -l template_source $argv[1]
        set -l template_list ""

        if test "$template_source" = "gi"

            echo -e "Available templates for gitignore.io:\n"
            set group_by 8

            set template_list (curl -sL https://www.gitignore.io/api/list | sed 's/[,\n]/ /g')

        else if test "$template_source" = "ag"

            echo -e "Available templates for api.github:\n"
            set group_by 4

            set template_list (curl -sL https://api.github.com/gitignore/templates | sed 's/\]//g; s/\[//g; s/[,"]//g')
            set template_list (string replace -a "\n" " " "$template_list")
        end

        set templates_list (string split -n " " "$template_list")
        set -l template_count (count $templates_list)
        set -l current 1

        while test $current -le $template_count;

            # Create the slice end index.
            set -l end (math $current + $group_by - 1)
            test $end -gt $template_count; and set -l end $template_count

            # Create the slice.
            set -l slice $templates_list[$current..$end]
            echo -e "\t -" (string join -n " | " $slice)

            set current (math $current + $group_by)
        end
    end

    # Fetches the given templates from the given source and writes it to the given output file (or stdout).
    function get_template -a template_source -a output

        set -l result ""
        set -l templates $argv[3..-1]

        for template in $templates

            echo -e "\r\tFetching template '$template'..."

            # Fetch the template from the correct source.
            test "$template_source" = "gi"; and set -l current (curl -sL https://www.gitignore.io/api/$template | string join "\n")
            test "$template_source" = "ag"; and set -l current (curl -sL https://api.github.com/gitignore/templates/$template | awk -F'"' '/source/ {print $4}')

            # Append the template to the result.
            set result "$result\n$current"
        end


        # Write the result to the given output file.
        if test "$output" != "stdout"

            echo -e "\n\tWriting to file '$output'..."
            set trimResult (string trim -c "\n" $result)

            echo -e $trimResult > $output

        # If bat is installed, use it to beautifully print the result.
        else if type -q bat

            echo -ne "\n"

            set trimResult (string trim -c "\n" $result)
            echo -e $trimResult | bat -l gitignore

        # Otherwise just print the result.
        else
            echo -e $result
        end

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

    if test $status -ne 0
        return 1
    end

    # If the variable _flag_help print the help message and exit.
    if test -n "$_flag_help"

        print_help
        return 0
    end

    # Set the template source. If empty default to 'gi'.
    set -l template_source "$_flag_source" 
    test -z "$_flag_source"; and set -l template_source "gi"

    # Check if the template source is valid.
    if test "$template_source" != "gi" -a "$template_source" != "ag"

        echoerr "\n\t[error] gitignore: Invalid source '$template_source'"
        return 1
    end

    # If the variable _flag_list print the list of available templates and exit.
    if test -n "$_flag_list"

        print_list $template_source
        return 0
    end  

    # Set the output file. If empty default to 'stdout'.
    set -l output "$_flag_output"
    test -z "$_flag_output"; and set -l output "stdout"

    get_template $template_source $output $argv
end
