#!/bin/bash
function calc () { awk "BEGIN{ 
    pi = 3.141592653589793
    e = 2.718281828459045
    print $* }" ;
}
function len () {
    echo ${#1}
}
function dt () {
    (( dtime=0 ))
    (( t1 = 0 ))
    if [ "$1" == "-0" ]; then
        t0=`date +%s`
    else
        t1=`date +%s`
        (( dtime = $t1-$t0 ))
        t0=$t1
        echo $dtime
    fi
}
function goPyOcr () {
    if [[ "$1" == "--loop" || "$1" == "-l" ]]; then
        for i in *$2*; do
            python /c/src/py-apps/ocr/pdfocr.py $i
            echo $i
        done
    else
        echo $(python /c/src/py-apps/ocr/pdfocr.py $1)
    fi
}
function cp+ () {
    if [ "$2" == "" ]; then
        preamble=$preamble
    else
        preamble=$2
    fi
    $(echo $preamble', '$1 | clip.exe)
}
function d2a () {
    dirs=()
    for dir in ./*$1*/; do
        [ -d "$dir" ] && dirs+=("$(basename "$dir")")
    done
    echo "The following folders have been stored in an array named \"dirs\":"
    printf '    %s\n' "${dirs[@]}"
}
function Re() {
    if [ $# == "-h" ] || [ $# == "--help" ] || [ $# == 0 ]; then
        echo "Usage: Re -d <diameter> -mu <viscosity> -u <velocity> -rho <density> [-Q <flowrate>]"
        echo "Calculate Reynolds number for fluid flow in a pipe."
        echo ""
        echo "Parameters:"
        echo "  -d    Diameter of the pipe (default unit: m)"
        echo "  -mu   Dynamic viscosity of the fluid (default unit: Pa·s)"
        echo "  -u    Velocity of the fluid (default unit: m/s)"
        echo "  -rho  Density of the fluid (default unit: kg/m³)"
        echo "  -Q    Volumetric flow rate of the fluid (default unit: m³/s)"
        echo ""
        echo "Units can be specified after the value, e.g., '0.1m', '500cp', '2in', etc."
        echo "Supported units:"
        echo "  Length: mm, cm, m, in, ft"
        echo "  Velocity: m/s, ft/s, m/min, ft/min, mph, kph"
        echo "  Viscosity: Pa·s, cP, dyne·s/cm²"
        echo "  Density: kg/m³, g/cm³, lbm/ft³"
        echo "  Flowrate: m³/s, m³/h, m³/d, bbl/d, bbl/h, kbpd"
        return
    fi
    # === Initialize variables ===
    d='' mu='' u='' rho='' Q=''
    i=1
    args=("$@")

    # === Unit conversion function ===
    convert_unit() {
        local value="$1"
        local unit="${2,,}"  # lowercase
        case "$unit" in
            ""|"m"|"m/s"|"pa-s"|"kg/m3"|"m3/s") echo "$value" ;;
            # --- Length ---
            "mm")   awk "BEGIN {print $value / 1000}" ;;
            "cm")   awk "BEGIN {print $value / 100}" ;;
            "inch"|"in") awk "BEGIN {print $value * 0.0254}" ;;
            "ft"|"feet") awk "BEGIN {print $value * 0.3048}" ;;
            # --- Velocity ---
            "ft/s") awk "BEGIN {print $value * 0.3048}" ;;
            "m/min") awk "BEGIN {print $value / 60}" ;;
            "ft/min") awk "BEGIN {print $value * 0.3048 / 60}" ;;
            "mph"|"mi/h") awk "BEGIN {print $value * 3600 / 1609.34}" ;;
            "kph"|"km/h") awk "BEGIN {print $value * 3600 * 1000}" ;;
            # --- Viscosity ---
            "cp"|"mpa-s"|"mpa.s")   awk "BEGIN {print $value * 0.001}" ;;
            "dyne") awk "BEGIN {print $value * 0.1}" ;;
            # --- Density ---
            "sg"|"g/cm3"|"g/cm^3")   awk "BEGIN {print $value * 1000}" ;;
            "lbm/ft3"|"lb/ft3"|"lbs/ft3"|"lbm/ft^3"|"lbm/cf") awk "BEGIN {print $value * 35.3147 / 2.20462 }" ;;
            # --- Flowrate ---
            "bbl/d") awk "BEGIN {print $value * 0.158987294928 / 86400}" ;;
            "bbl/h") awk "BEGIN {print $value * 0.158987294928 / 3600}" ;;
            "kbpd"|"k-bbl/d"|"kbbl/d") awk "BEGIN {print $value * 0.158987294928 / 86400 * 1000}" ;;
            "m3/d")  awk "BEGIN {print $value / 86400}" ;;
            "m3/h")  awk "BEGIN {print $value / 3600}" ;;
            *) echo "Error: Unknown unit '$unit'" >&2; echo "N/A" ;;
        esac
    }

    # === Argument parser ===
    while [ $i -le $# ]; do
        arg="${args[$((i-1))]}"
        case "$arg" in
            -d|-mu|-u|-rho|-Q)
                val="${args[$i]}"
                next="${args[$((i+1))]}"
                # If next is not a flag, treat it as unit
                if [[ "$next" =~ ^- ]]; then
                    unit=""
                else
                    unit="$next"
                    ((i++))
                fi
                # Detect combined form (like 0.1m)
                if [[ "$val" =~ ^([0-9.]+)([a-zA-Z/-]+)$ ]]; then
                    value="${BASH_REMATCH[1]}"
                    unit="${BASH_REMATCH[2]}"
                else
                    value="$val"
                fi
                # Convert and assign
                conv=$(convert_unit "$value" "$unit")
                case "$arg" in
                    -d) d="$conv" ;;
                    -mu) mu="$conv" ;;
                    -u) u="$conv" ;;
                    -rho) rho="$conv" ;;
                    -Q) Q="$conv" ;;
                esac
                ;;
        esac
        ((i++))
    done

    # === Compute Reynolds Number ===
    if [ -n "$u" ] && [ "$u" != "0" ]; then
        Re=$(awk -v d="$d" -v mu="$mu" -v u="$u" -v rho="$rho" 'BEGIN {print rho * u * d / mu}')
    elif [ -n "$Q" ] && [ "$Q" != "0" ]; then
        Re=$(awk -v d="$d" -v mu="$mu" -v Q="$Q" -v rho="$rho" 'BEGIN {pi=3.141592653589793; print 4*Q*rho/(pi*d*mu)}')
    else
        Re="N/A"
    fi

    # === Output ===
    if [[ "$Re" =~ ^[0-9eE.+-]+$ ]]; then
        printf 'Re = %g\n' "$Re"
    else
        printf 'Re = %s\n' "$Re"
    fi
}

function cpdir () {
    if [[ $1 == "-i" ]] || [[ $1 == "--input" ]]; then
        mapfile -t dirs < <(ls -1)
    else
        for d in "${dirs[@]}"; do
            mkdir -p "$d"
        done
    fi
}

box() {
    local text=""
    local width=0

    while (( $# )); do
        case "$1" in
            -w|--width)  width=$2; shift 2 ;;
            --width=*)   width=${1#*=}; shift ;;
            -w*)         width=${1#-w}; shift ;;
            *)           text="$1"; shift ;;
        esac
    done

    [[ -z "$text" ]] && { echo "Usage: box [-w N] <text>"; return 1; }

    # Visible length (strip ANSI codes)
    local visible=$(printf '%b' "$text" | sed -E 's/\x1B\[[0-9;]*[mK]//g')
    local len=${#visible}

    # Final outer width
    (( width < len + 8 )) && width=$((len + 8))
    (( width <= 0 )) && width=$((len + 8))

    # Space available *inside* the box (between the two │)
    local inside=$(( width - 4 ))

    local left=$(( (inside - len) / 2 ))
    local right=$(( inside - len - left ))

    local line=$(printf '─%.0s' $(seq 1 $inside))

    printf '┌─%s─┐\n' "$line"
    printf '│ %*s%b%*s │\n' "$left" "" "$text" "$right" ""
    printf '└─%s─┘\n' "$line"
}