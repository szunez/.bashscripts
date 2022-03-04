function cal() {
    month=("January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December")
    (( idx_m = 0 ))
    (( lastday = 0 ))
    dend=()
    if [ "$2" == "" ]; then
        if [ "$1" == "" ]; then
            yyyy0=`date +%Y`
            (( idx_m = `date +%m` - 1 ))
        elif (( $1 <= 12 )); then
            yyyy0=`date +%Y`
            (( idx_m = $1 - 1 ))
        elif (( $1 > 12 )) && (( ${#1} == 4 )); then
            yyyy0=$1
            (( idx_m = `date +%m` - 1 ))
        elif (( $1 > 12 )) && (( ${#1} < 4 )); then
            (( yyyy0 = 2000 + $1 ))
            (( idx_m = `date +%m` - 1 ))
        else
            yyyy0=`date +%Y -d"$1"`
            ((idx_m = `date +%m -d"$1"` - 1 ))
        fi
    else
        if (( $2 > 12 )) && (( ${#2} == 4 )); then
            yyyy0=$2
            (( idx_m = $1 - 1 ))
        elif (( $2 > 12 )) && (( ${#2} < 4 )); then
            (( yyyy0 = 2000 + $2 ))
            (( idx_m = $1 - 1 ))
        elif (( $1 > 12 )) && (( ${#1} == 4 )); then
            yyyy0=$1
            (( idx_m = $2 - 1 ))
        elif (( $1 > 12 )) && (( ${#1} < 4 )); then
            (( yyyy0 = 2000 + $1 ))
            (( idx_m = $2 - 1 ))
        fi
    fi
    (( mm0 = $idx_m + 1 ))
    dend+=( `date +%u -d"$yyyy0-$mm0-01"` )
    (( mm1 = $mm0 + 1))
    if (( $mm1 > 12 )); then
        (( mm1 = 1 ))
        (( yyyy1 = $yyyy0 + 1 ))
    else
        (( yyyy1 = $yyyy0 ))
    fi
    (( lastdays = `date +%s -d"$yyyy1-$mm1-01 00:00"` - `date +%s -d"$yyyy0-$mm0-01 00:00"` ))
    lastday=`printf %.0f "$((10**3 * $lastdays/86400))e-3"`
    padding0='          '
    padding1='                    '
    printf "\n%s%s%s\n" "${padding0:${#month[idx_m]}} ${month[idx_m]} `date +%Y`"
    echo 'Su Mo Tu We Th Fi Sa'
    line0=''
    if (( ${dend[0]} >= 1 )) && (( ${dend[0]} < 6 )); then
        for (( d=1; d<=${dend[0]}; d++ ))
            do
                line0=$line0'   '
        done
        line0="$line0"'01'
        for (( dd=$d + 1; dd<=7; dd++ ))
            do
                (( dprint = dd - $d + 1 ))
                line0=$line0' 0'$dprint
        done
        echo "$line0"
    elif (( ${dend[0]} == 6 )); then
        line0='               01 02'
        echo "$line0"
        (( d = 0 ))
        (( dprint = 2 ))
    elif (( ${dend[0]} == 7 )); then
        line0='                  01'
        echo "$line0"
        (( d = 0 ))
        (( dprint = 1 ))
    else
        (( d = 0 ))
    fi
    (( dprint++ ))
    dend+=( $(($dprint + 6)) )
    line1='0'$dprint
    dd=0
    for (( dd=$dprint+1; dd<=${dend[1]}; dd++ ))
        do
            (( dprint++ ))
            if (( $dprint < 10 )); then
                line1=$line1' 0'$dprint
            else
                line1=$line1' '$dprint
            fi
    done
    echo "$line1"
    (( dprint++ ))
    dend+=( $(($dprint + 6)) )
    if (( $dprint < 10 )); then
        line2='0'$dprint
    else
        line2=$dprint
    fi
    dd=0
    for (( dd=$dprint+1; dd<=${dend[2]}; dd++ ))
        do
            (( dprint++ ))
            if (( $dprint < 10 )); then
                line2=$line2' 0'$dprint
            else
                line2=$line2' '$dprint
            fi
    done
    echo "$line2"
    (( dprint++ ))
    dend+=( $(( $dprint + 6 )) )
    if (( ${dend[3]} > $lastday )); then
        ((${dend[3]} = $lastday))
    fi
    line3=$dprint
    dd=0
    for (( dd=$dprint+1; dd<=${dend[3]}; dd++ ))
        do
            (( dprint++ ))
            line3=$line3' '$dprint
    done
    echo "$line3"
    (( dprint++ ))
    dend+=( $(( $dprint + 6 )) )
    if (( ${dend[4]} > $lastday )); then
        dend[4]=$lastday
    fi
    line4=$dprint
    dd=0
    for (( dd=$dprint+1; dd<=${dend[4]}; dd++ ))
        do
            (( dprint++ ))
            line4=$line4' '$dprint
    done
    echo "$line4"
    (( dprint++ ))
    dend+=( $(( $dprint + 6 )) )
    if (( ${dend[5]} > $lastday )); then
        dend[5]=$lastday
    fi
    if (( ${dend[5]} <= $lastday )) && (( ${dend[5]} > ${dend[4]} )); then
        line5=$dprint
        for (( dd=$dprint+1; dd<=${dend[5]}; dd++ ))
            do
                (( dprint++ ))
                line5=$line5' '$dprint
        done
        echo "$line5"
    fi
}