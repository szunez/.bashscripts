function cal2() {
    highlight='\033[1;33m'
    month=("January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December")
    (( mm = 0))
    (( ddN = 0 ))
    calendar=''
    if [ "$2" == "" ]; then
        if [ "$1" == "" ]; then
            yyyy0=`date +%Y`
            (( mm = `date +%m` - 1 ))
        elif (( $1 <= 12 )); then
            yyyy0=`date +%Y`
            (( mm = $1 - 1 ))
        elif (( $1 > 12 )) && (( ${#1} == 4 )); then
            yyyy0=$1
            (( mm = `date +%m` - 1 ))
        elif (( $1 > 12 )) && (( ${#1} < 4 )); then
            (( yyyy0 = 2000 + $1 ))
            (( mm = `date +%m` - 1 ))
        else
            yyyy0=`date +%Y -d"$1"`
            (( mm = `date +%m -d"$1"` - 1 ))
        fi
    else
        if (( $2 > 12 )) && (( ${#2} == 4 )); then
            yyyy0=$2
            (( mm = $1 - 1 ))
        elif (( $2 > 12 )) && (( ${#2} < 4 )); then
            (( yyyy0 = 2000 + $2 ))
            (( mm = $1 - 1 ))
        elif (( $1 > 12 )) && (( ${#1} == 4 )); then
            yyyy0=$1
            (( mm = $2 - 1 ))
        elif (( $1 > 12 )) && (( ${#1} < 4 )); then
            (( yyyy0 = 2000 + $1 ))
            (( mm = $2 - 1 ))
        fi
    fi
    (( mm0 = $mm + 1 ))
    (( mm1 = $mm0 + 1 ))
    if (( $mm1 > 12 )); then
        (( mm1 = 1 ))
        (( yyyy1 = $yyyy0 + 1 ))
    else
        (( yyyy1 = $yyyy0 ))
    fi
    (( ddN = `date +%s -d"$yyyy1-$mm1-01 00:00"` - `date +%s -d"$yyyy0-$mm0-01 00:00"` ))
    ddN=`printf %.0f "$((10**3 * $ddN/86400))e-3"`
    p0=`date +%u -d"$yyyy0-$mm0-01"`
    (( pN = $p0 + $ddN ))
    if (( $p0 == 7 )); then
        (( pN = $ddN ))
    fi
    (( p = 0 ))
    (( d = 0 ))
    for (( i=0; i<$pN; i++ ))
        do
            if (( $p > 7 )); then
                p=1
            fi
            if (( $i < $p0 )) && [ "$p0" != "7" ]; then
                calendar=$calendar'   '
            else
                (( d++ ))
                if [ `date +%d` == $d ] && (( `date +%m` == $mm0 )) && (( `date +%Y` == $yyyy0 )); then
                    colour=$highlight
                else
                    colour='\033[0m'
                fi
                if (( $d <= 9 )); then
                    dd='0'$d' '
                else
                    dd=$d' '
                fi
                if (( $p == 6 )); then
                    dd=$dd'\n'
                fi
                calendar=$calendar$colour$dd
            fi
        (( p++ ))
    done
    padding0='          '
    highlight='\033[1;33m'
    echo -e "\n${padding0:${#month[mm]}} \033[0;32m${month[mm]} `date +%Y -d"$yyyy0-01-01"`"
    echo -e "\033[0;35mSu Mo Tu We Th Fi Sa\033[0m"
    echo -e "$calendar"
}