#!/bin/bash

# File to store paths
PATH_FILE="$HOME/.cd_paths"

# Ensure the path file exists
touch "$PATH_FILE"

cd+() {
    case "$1" in
        -s|--save)
            # Save the current directory to the file
            pwd >> "$PATH_FILE"
            echo "Directory saved."
            ;;
        -l|--list)
            # List the top 5 saved directories
            if [ -s "$PATH_FILE" ]; then
                echo "Top 5 saved directories:"
                head -n 5 "$PATH_FILE" | nl
            else
                echo "No saved directories."
            fi
            ;;
        *)
            # Navigate to the directory specified by the argument
            if [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null; then
                local line_number=$1
                local target_dir
                target_dir=$(sed "${line_number}q;d" "$PATH_FILE")
                if [ -n "$target_dir" ]; then
                    cd "$target_dir" || echo "Failed to change directory."
                else
                    echo "No such directory entry."
                fi
            else
                echo "Usage:"
                echo "cd+ -s | --save    - Save the current directory"
                echo "cd+ -l | --list    - List the top 5 saved directories"
                echo "cd+ [n]            - Change to the nth saved directory"
            fi
            ;;
    esac
}