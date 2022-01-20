function watchlist () {
    if [ "$1" == "--edit" ] || [ "$1" == "-e" ]; then
        code "$funnelDir"/watchlist.csv
    fi
    sed -i "1s/^/`date +%Y-%m-%dT%H:%M`,$1,$2,$3\n/" "$funnelDir"/watchlist.csv
}