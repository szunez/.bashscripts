#!/bin/bash
function lerp(){
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        echo -e "Usage: lerp x x0 x1 y0 y1\n       linear interpolation returns y(x) based\n       on points (x0, y0) and (x1, y1)"
        return
    fi
    local px=$(awk -v x="$1" -v x0="$2" -v x1="$3" -v y0="$4" -v y1="$5" 'BEGIN { print y0 + (x - x0) * (y1 -  y0) / (x1 - x0) }')
    echo $px
    `echo $px | clip.exe`
}