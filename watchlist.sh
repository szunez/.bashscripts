function watchlist () {
    sed -i "1s/^/`date +%Y.%m.%d-%H:%M`,$1,$2,$3\n/" "$funnelDir"/watchlist.csv
}