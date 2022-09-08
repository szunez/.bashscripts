function cal() {
    usebd=''
    (( i = 0 ))
    if [ ! -e ~/.bashscripts/cal.config ]; then
        touch ~/.bashscripts/cal.config
        echo "### Configuration for cal.sh ###" > ~/.bashscripts/cal.config
    fi
    source ~/.bashscripts/cal.config
    while read LINE; do (( i++ )); done < ~/.bashscripts/cal.config
    if [ "$birthday" == "" ]; then
        echo -n "Would you like me to wish you happy birthday? [y/n]:"
        read -r usebd
    fi
    if [ "$usebd" == "n" ] || [ "$usebd" == "N" ]; then
        echo -e "\nbirthday=9999-01-01" >> ~/.bashscripts/cal.config
        birthday="9999-01-01"
    elif [ "$usebd" == "y" ] || [ "$usebd" == "Y" ]; then
        echo -n "Great, what year were you born in? [yyyy]:"
        read -r bdyyyy
        echo -n "What month were you born in? [mm]:"
        read -r bdmm
        echo -n "What day were you born in? [dd]:"
        read -r bddd
        echo -e "\nbirthday=$bdyyyy-$bdmm-$bddd" >> ~/.bashscripts/cal.config
        birthday=$bdyyyy'-'$bdmm'-'$bddd
    fi
    highlight='\033[1;33m'
    celebrate='\033[1;36m'
    yyyy_bd=`date +%Y -d"$birthday"`
    mm_bd=`date +%-m -d"$birthday"`
    dd_bd=`date +%-d -d"$birthday"`
    month=("January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December")
    (( mm = 0))
    (( ddN = 0 ))
    msg=''
    calendar=''
    if [ "$2" == "" ]; then
        if [ "$1" == "" ]; then
            yyyy0=`date +%Y`
            (( mm = `date +%-m` - 1 ))
        elif (( $1 <= 12 )); then
            yyyy0=`date +%Y`
            (( mm = $1 - 1 ))
        elif (( $1 > 12 )) && (( ${#1} == 4 )); then
            yyyy0=$1
            (( mm = `date +%-m` - 1 ))
        elif (( $1 > 12 )) && (( ${#1} < 4 )); then
            (( yyyy0 = 2000 + $1 ))
            (( mm = `date +%-m` - 1 ))
        else
            yyyy0=`date +%Y -d"$1"`
            (( mm = `date +%-m -d"$1"` - 1 ))
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
    (( age = $yyyy0 - $yyyy_bd))
    if (( ${age[@]:(( ${#age} - 1)):1} == 1 )); then
        if  (( $age < 4)) || (( $age > 20 )); then
            ord='st'
        else
            ord='th'
        fi
    elif (( ${age[@]:(( ${#age} - 1)):1} == 2 )); then
        if  (( $age < 4)) || (( $age > 20 )); then
            ord='nd'
        else
            ord='th'
        fi
    elif (( ${age[@]:(( ${#age} - 1)):1} == 3 )); then
        if  (( $age < 4)) || (( $age > 20 )); then
            ord='rd'
        else
            ord='th'
        fi
    else
        ord='th'
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
                if (( $d <= 9 )); then
                    dd='0'$d' '
                else
                    dd=$d' '
                fi
                if [ `date +%d` == $dd ] && (( `date +%-m` == $mm0 )) && (( `date +%Y` == $yyyy0 )); then
                    colour=$highlight
                elif [ $d == $dd_bd ] && (( $mm_bd == $mm + 1 )); then
                    colour=$celebrate
                    msg=$celebrate'happy '$age$ord' birthday!'
                else
                    colour='\033[0m'
                fi
                if (( $p == 6 )); then
                    dd=$dd'\n'
                fi
                calendar=$calendar$colour$dd
            fi
        (( p++ ))
    done
    padding0='          '
    echo -e "\n${padding0:${#month[mm]}} \033[0;32m${month[mm]} `date +%Y -d"$yyyy0-01-01"`"
    echo -e "\033[0;35mSu Mo Tu We Th Fi Sa\033[0m"
    echo -e "$calendar"
    echo -e $msg
}