#!/bin/bash
function goMba () {
    if [[ "$1" = "--mk" ]] || [[ "$1" = "-mk" ]] || [[ "$1" = "--make" ]] || [[ "$1" = "-m" ]]; then
        courseDirs=("0 text" "1 asynch" "2 lecture" "3 class" "4 problems" "5 exam")
        nnn=$2
        course=$3
        newDir=~/OneDrive\ -\ Evoleap\,\ LLC/Documents/MBA\@Rice/$2'-'$3
        echo $newDir
        mkdir "$newDir"
        for (( i=0; i < ${#courseDirs}; i++)); do
            mkdir "$newDir"/"${courseDirs[i]}"
        done
        cd "$newDir";explorer.exe .
    elif [[ "$1" = "--rn" ]] || [[ "$1" = "-rn" ]] || [[ "$1" = "--rename" ]] || [[ "$1" = "-r" ]]; then
        local search_text="$2"
        local prefix="$3"
        local suffix="$4"
        # Check if prefix and suffix are empty or not
        if [ -n "$prefix" ]; then
            prefix="${prefix}"
        fi
        if [ -n "$suffix" ]; then
            suffix="_${suffix}"
        fi
        local files=()
        local i=0
        # Enumerate and list files matching the search_text
        for file in *; do
            if [ -f "$file" ] && [[ "$file" == *"$search_text"* ]]; then
                files+=("$file")
                ((i++))
                echo "$i: $file"
            fi
        done
        if [ "$i" -eq 0 ]; then
            echo "No matching files found."
        fi
        # Prompt the user to select a file by number
        read -p "Enter the number of the file you wish to rename: " choice
        if [[ ! "$choice" =~ ^[0-9]+$ || "$choice" -lt 1 || "$choice" -gt "$i" ]]; then
            echo "Invalid choice. Please enter a valid number."
        fi
        local selected_file="${files[choice-1]}"
        # Rename the selected file
        new_name="${prefix}${selected_file}${suffix}"
        mv "$selected_file" "$new_name"
        echo "File renamed to: $new_name"
        # Check if the correct number of arguments is provided
        if [ "$#" -lt 1 ]; then
            echo "Usage: $0 <search_text> [prefix] [suffix]"
        fi
    else
        targetDirPath=""
        for arg in "$@"; do
            if [[ "$arg" != "" ]]; then
                targetDirPath+='*'$arg'*/'
            fi
        done
        cd ~/OneDrive\ -\ Evoleap\,\ LLC/Documents/MBA\@Rice/$targetDirPath;explorer.exe .
    fi
}