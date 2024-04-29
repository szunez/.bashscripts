function goOlga () {
    #**********************************************************************************
    #  D  E  F  I  N  I  T  I  O  N  S
    #**********************************************************************************
    case=$(ls $1)
    vOLGA=OLGA-2024.1.1.exe
    pOLGA='C:\Program Files\Schlumberger\OLGA 2024.1.1\OlgaExecutables\'
    name=${#case[@]}
    echo $case
    read -p "Press any key to resume"
    cmd00='color 2A'
    cmd01='@echo off'
        for (( j=0; j<=${#case[@]}; j++)) do
            cmd02[j]='title "Running '$case' with '$vOLGA'"'
            cmd03[j]='call "'$pOLGA$vOLGA'" "'$case'"'
        done
    cmd04='title "Finished '$name'"'
    cmd05='color 47'
    cmd06='pause'
    cmd07='exit'
    #**********************************************************************************
    #  P  R  O  G  R  A  M  M  E
    #**********************************************************************************
    #rm $name.bat
    Touch $name.bat
    echo $cmd00 >> $name.bat
    echo $cmd01 >> $name.bat
        j=0
        for (( j=0; j<=${#case[@]}; j++)) do
            echo $cmd02 >> $name.bat
            echo $cmd03 >> $name.bat	
        done
    echo $cmd04 >> $name.bat
    echo $cmd05 >> $name.bat
    echo $cmd06 >> $name.bat
    echo $cmd07 >> $name.bat
    start $name.bat
    #**********************************************************************************
    #  D  E  B  U  G     C  O  D  E
    #**********************************************************************************
    # 	@ i = 0
    #	foreach j($case)
    #		set cmd02 = 'title "Running '$case[$i]' with '$vOLGA'"'
    #		set cmd03 = 'call "'$pOLGA$vOLGA'" "'$case[$i]'"'
    #		@ i++
    #	end
    #**********************************************************************************
    #  E  N  D     E  X  E  C  U  T  I  O  N
    #**********************************************************************************
}
function statusOlga() {
    # Define the file extensions to check for
    input_extensions=("key" "inp" "genkey")
    output_extensions=("out" "tpl" "ppl" "rsw")
    success_string="****************  NORMAL STOP IN EXECUTION  ****************"

    # Extract the base filenames from the list of filenames
    input_base_names=$(find . -maxdepth 1 -type f \( -name "*.key" -o -name "*.inp" -o -name "*.genkey" \) | sed -E 's/(\.(key|inp|genkey))?$//' | sed 's|^\./||' | sort -u)
    output_base_names=$(find . -maxdepth 1 -type f \( -name "*.out" -o -name "*.tpl" -o -name "*.ppl" -o -name "*.rsw" \) | sed -E 's/(\.(out|tpl|ppl|rsw))?$//' | sed 's|^\./||' | sort -u)

    # Combine input and output base names
    all_base_names=$(echo -e "$input_base_names\n$output_base_names" | sort -u)

    # Initialize counters
    total_base_names=$(echo "$all_base_names" | wc -l)
    matched_base_names=0
    crashed_base_names=""
    unrun_base_names=""

    # Iterate over each base filename
    for base_name in $all_base_names; do
        found=0
        # Check if the base filename has any of the output extensions
        for ext in "${output_extensions[@]}"; do
            if [ -e "$base_name.$ext" ]; then
                # Check if success string is present in the output file
                if grep -q "$success_string" "$base_name.$ext"; then
                    found=1
                    ((matched_base_names++))
                else
                    crashed_base_names+="$base_name\n"
                    found=1
                fi
                break
            fi
        done
        # If the base filename doesn't have any of the output extensions and it didn't crash, print it
        if [ $found -eq 0 ]; then
            unrun_base_names+="$base_name\n"
        fi
    done

    # Print job status
    echo "Successfully ran $matched_base_names of $total_base_names cases."
    if [ ! -z "$crashed_base_names" ]; then
        echo "The following case(s) ran but either crashed or are still running:"
        echo -e "$crashed_base_names"
    fi
    if [ ! -z "$unrun_base_names" ]; then
        echo "The following cases did not successfully run:"
        echo -e "$unrun_base_names"
    fi
}
function renOlga (){
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 <existing_text> <replacement_text>"
        exit 1
    fi
    existing_text="$1"
    replacement_text="$2"
    for file in *"$existing_text"*; do
        new_name=$(echo "$file" | sed "s/$existing_text/$replacement_text/")
        mv "$file" "$new_name"
    done
}
function goP(){
    targetDirPath=""
    for arg in "$@"; do
        if [[ "$arg" != "" ]]; then
            targetDirPath+='*'$arg'*/'
        fi
    done
    cd /p/$targetDirPath;explorer.exe .
}
function flowpad(){
    app=~/AppData/Local/flowpad/app-1.2.1.646/flowpad.exe
    "$app" "$@" &
}
function flotools(){
    app=~/AppData/Local/evoleap/flotools/bin/flotools.exe
    "$app" "$@" &
}