function watchlist () {
    flag_edit=false
    flag_list=false
    list="watch"

    # Loop through all arguments
    for ((i=1; i<=$#; i++)); do
        arg="${!i}"  # Get the current argument
        if [[ "$arg" == "--edit" ]] || [[ "$arg" == "-e" ]]; then
            flag_edit=true
        elif [[ "$arg" == "--list" ]] || [[ "$arg" == "-l" ]]; then
            flag_list=true
            # Check if there's another argument after "--list" or "-l"
            if ((i < $#)); then
                ((i++))
                list="${!i}"
            fi
        fi
    done
    if [ "$flag_edit" = true ]; then
        code "$funnelDir"/watchlist.csv
    else
        if [ "$flag_list" = true ]; then
            # Check if the list file exists
            if [ ! -f "$funnelDir/$list"list.csv ]; then
                touch "$funnelDir/$list"list.csv
                echo "$(date +%Y-%m-%dT%H:%M),$1,$2,$3" > "$funnelDir/$list"list.csv
            fi
        fi
        sed -i "1s/^/$(date +%Y-%m-%dT%H:%M),$1,$2,$3\n/" "$funnelDir"/"$list"list.csv
    fi
}