#!/bin/bash

cd "$(dirname "$0")" || exit 1

pattern="${1:-*}"

# Use find to match directories one level deep containing the pattern, excluding .
for dir in $(find . -maxdepth 1 -type d -name "*${pattern}*" ! -path .); do
    dir=${dir#./}  # Remove ./ prefix from find output
    if [ ! -d "$dir" ]; then continue; fi
    echo "§ ${dir%/}"
    
    # Collect values in temporary files
    wc_file=$(mktemp)
    qlst_file=$(mktemp)
    od_file=$(mktemp)
    nequipipe_file=$(mktemp)
    waterdensity_file=$(mktemp)
    pressure_file=$(mktemp)
    
    for file in "${dir}"/*.key; do
        if [ ! -f "$file" ]; then continue; fi
        filename=$(basename "$file")
        
        # Extract WC from filename with regex that handles integer or decimal
        if [[ $filename =~ _WC-([0-9]+(\.[0-9]+)?) ]]; then
            wc=${BASH_REMATCH[1]}
            wc_percent=$(awk "BEGIN {printf \"%.0f\", ${wc} * 100}")
            echo "$wc_percent" >> "$wc_file"
        fi
        
        # Extract QLST from filename with flexible unit (KBD or kSTBD)
        if [[ $filename =~ _QLST-([0-9]+)[kK](STB)?D ]]; then
            qlst=${BASH_REMATCH[1]}
            echo "$qlst" >> "$qlst_file"
        fi
        
        # Extract OD from filename
        if [[ $filename =~ FLOW-([0-9.]+)in ]]; then
            od=${BASH_REMATCH[1]}
            echo "$od" >> "$od_file"
        fi
        
        # Extract NEQUIPIPE from the specific line
        nequipipe=$(grep 'PIPE LABEL=\"PIPE-1\", WALL=\"RISE-10in' "$file" | grep -o 'NEQUIPIPE=[0-9]*' | cut -d'=' -f2)
        if [ -n "$nequipipe" ]; then
            echo "$nequipipe" >> "$nequipipe_file"
        fi
        
        # Extract WATERDENSITY from file content
        waterdensity=$(grep "TUNING WATERDENSITY" "$file" | awk '{print $NF}' | grep -o '[0-9.]*')
        if [ -n "$waterdensity" ]; then
            echo "$waterdensity" >> "$waterdensity_file"
        fi
        
        # Extract PRESSURE from file content specifically from PRESSURE=(value)
        pressure=$(grep "TYPE=PRESSURE" "$file" | grep -o 'PRESSURE=(\([0-9.]\+\))' | grep -o '[0-9.]\+')
        if [ -n "$pressure" ]; then
            echo "$pressure" >> "$pressure_file"
        fi
    done
    
    # Function to print parameter
    print_param() {
        local temp_file=$1
        local name=$2
        local unit=$3
        if [ -s "$temp_file" ]; then
            uniques=$(sort -n "$temp_file" | uniq)
            count=$(echo "$uniques" | wc -l)
            list=$(echo "$uniques" | tr '\n' ',' | sed 's/,$//; s/,/, /g')
            if [ $count -eq 1 ]; then
                echo "○ 1x $name= $list$unit"
            else
                echo "○ ${count}x $name= $list$unit"
            fi
        else
            echo "○ 0x $name"
        fi
    }
    
    print_param "$wc_file" "WC" "%"
    print_param "$qlst_file" "QLST" " kSTB/d"
    print_param "$od_file" "OD" "\""
    print_param "$nequipipe_file" "NEQUIPIPE" ""
    print_param "$waterdensity_file" "WATERDENSITY" ""
    print_param "$pressure_file" "PRESSURE" " kgf/cm2"
    
    # Bathymetry from directory name
    if echo "${dir%/}" | grep -iq "Flat"; then
        bath="bathymetry flat "
    else
        bath="bathymetry undulated"
    fi
    echo "○ 1x $bath"
    
    # Cleanup
    rm -f "$wc_file" "$qlst_file" "$od_file" "$nequipipe_file" "$waterdensity_file" "$pressure_file"
    
    # Add newline between folder outputs
    echo ""
done