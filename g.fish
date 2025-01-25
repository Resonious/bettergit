#!/usr/bin/env fish

# Define command name once
set -l cmd g

# Define completions
complete -c $cmd -f
complete -c $cmd -n "__fish_use_subcommand" -a "c" -d "commit"
complete -c $cmd -n "__fish_use_subcommand" -a "co" -d "checkout"
complete -c $cmd -n "__fish_use_subcommand" -a "new" -d "new branch"
complete -c $cmd -n "__fish_use_subcommand" -a "s" -d "status"
complete -c $cmd -s h -l help -d "Show help"

complete -c $cmd -n "__fish_seen_subcommand_from c" -l all -d "commit"
complete -c $cmd -n "__fish_seen_subcommand_from co" -l all -d "checkout"
complete -c $cmd -n "__fish_seen_subcommand_from new" -l all -d "new"
complete -c $cmd -n "__fish_seen_subcommand_from s" -l all -d "status"

# Implement the command functionality
function $cmd --description "Better Git"
    # Parse options
    argparse 'h/help' 'force' 'all' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: $cmd [options] command [args]"
        echo
        echo "Commands:"
        echo "  c [MESSAGE]       Commit, message optional"
        echo "  co BRANCH         Checkout"
        echo "  new BRANCH        Checkout new branch"
        echo "  s                 Status"
        echo
        echo "Options:"
        echo "  -h, --help        Show this help message"
        return 0
    end

    # Ensure we have a command
    if test (count $argv) -eq 0
        echo "Error: No command specified"
        return 1
    end

    # Get the subcommand
    set -l subcmd $argv[1]
    set -e argv[1]

    # Create data directory if it doesn't exist
    set -l tmp (mktemp)

    switch $subcmd
        case c
            if test (count $argv) -eq 0
                echo "Generating commit message"
                git add -A
                git diff --staged > $tmp
                set message (aichat -f $tmp "Respond with a one-line quick message describing the above changes. No fluff, only the description. Do not capitalize the first letter, and do not end in a period")
                git commit -m $message
                return 0
            end

            git add -A
            git commit -m $argv

        case co
            if test (count $argv) -eq 0
                echo "Error: No branch specified"
                return 1
            end

            git checkout $argv

        case new
            if test (count $argv) -eq 0
                echo "Error: No branch specified"
                return 1
            end

            git checkout -b $argv

        case s
            git status

        case '*'
            git $subcmd
    end
end
