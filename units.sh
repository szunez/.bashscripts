#!/bin/bash
function units(){
    if [[ "$1" == "--help" ]] || [[ $1 == "-h" ]]; then
        help_message
        return
    elif [[ "$2" == "api" ]]; then
        sg_to_api
        return
    fi
    local value_source=$1
    local unit_source=$2
    local unit_target=$3
    declare -A conversion_table=(
        ["barg"]="barg 100000 101325"
        ["bara"]="bara 100000 0"
        ["psia"]="psia 6894.757 0"
        ["psig"]="psig 6894.757 101325"
        ["atm"]="atm 101325 0"
        ["kgf/cm2"]="kgf/cm2 98066.50 0"
        ["Pa"]="Pa 1 0"
        ["C"]="C 1 273.15"
        ["F"]="F 0.555556 255.372222"
        ["K"]="K 1 0"
        ["R"]="R 0.555556 0"
        ["s"]="s 1 0"
        ["sec"]="s 1 0"
        ["second"]="s 1 0"
        ["seconds"]="s 1 0"
        ["min"]="s 60 0"
        ["minute"]="s 60 0"
        ["minutes"]="s 60 0"
        ["h"]="s 3600 0"
        ["hr"]="s 3600 0"
        ["hour"]="s 3600 0"
        ["hours"]="s 3600 0"
        ["d"]="s 86400 0"
        ["dy"]="s 86400 0"
        ["day"]="s 86400 0"
        ["days"]="s 86400 0"
        ["in"]="in 0.0254 0"
        ["inch"]="inch 0.0254 0"
        ["ft"]="ft 0.3048 0"
        ["foot"]="foot 0.3048 0"
        ["mi"]="mi 1609.344 0"
        ["mile"]="mile 1609.344 0"
        ["mm"]="mm 0.001 0"
        ["cm"]="cm 0.01 0"
        ["m"]="m 1 0"
        ["km"]="km 1000 0"
        ["USgal"]="USgal 0.003785412 0"
        ["gal"]="gal 0.003785412 0"
        ["bbl"]="bbl 0.1589873 0"
        ["L"]="L 0.001 0"
        ["mL"]="mL 0.000001 0"
        ["ml"]="ml 0.000001 0"
        ["cc"]="cc 0.000001 0"
        ["cm3"]="cm3 0.000001 0"
        ["ft3"]="ft3 0.02831685 0"
        ["cf"]="ft3 0.02831685 0"
        ["m3"]="m3 1 0"
        ["g/cm3"]="kg/m3 1000 0"
        ["kg/m3"]="g/cm3 0.001 0"
        ["kg"]="kg 1 0"
        ["g"]="kg 1000 0"
        ["mg"]="kg 1000000 0"
        ["lbs"]="kg 0.45359237 0"
        ["tonne"]="kg 0.001 0"
        ["ton"]="kg 0.00110231131 0"
        ["slug"]="kg 0.0685217659 0"
        ["kip"]="kg 0.0022046226 0"
    )
    local value_si=$(convert_to_si $value_source $unit_source)
    local value_target=$(convert_from_si $value_si $unit_target)
    echo "$value_target $unit_target"
    `echo $value_target $unit_target | clip.exe`
}
function convert_to_si(){
    local key="$2"
    local conversion=(${conversion_table[$key]})
    local gain=${conversion[1]}
    local offset=${conversion[2]}
    awk -v value="$1" -v gain="$gain" -v offset="$offset" 'BEGIN {print (value * gain) + offset}'
}
function convert_from_si(){
    local key="$2"
    local conversion=(${conversion_table[$key]})
    local gain=${conversion[1]}
    local offset=${conversion[2]}
    awk -v value="$1" -v gain="$gain" -v offset="$offset" 'BEGIN {print (value - offset) / gain}'
}
function sg_to_api(){
    local api="$1"
    awk -v value="$api" 'BEGIN {print 141.5 / (131.5 + value)}'
}
function help_message(){
    cat <<EOF
Usage: <value> <source_unit> <target_unit>

This script converts units of various physical quantities such as pressure, temperature, etc.

Supported units:
- Pressure: barg, bara, psia, psig, atm, kgf/cm2, Pa
- Temperature: C, F, K
- Time: s, sec, second, seconds, min, minute, minutes, h, hr, hour, hours, d, dy, day, days
- Length: in, inch, ft, foot, mi, mile, mm, cm, m, km
- Volume: USgal, gal, bbl, L, mL, ml, cc, cm3, ft3, cf, m3

Examples:
25 barg psia      # Convert 25 barg to psia
100 F C           # Convert 100 Fahrenheit to Celsius
EOF
}