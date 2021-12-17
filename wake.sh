function wake() {
    if [ "$1" == "--up" ]; then
        '/c/Caffeine/caffeine64.exe' & echo 'caffeine64.exe is up'
    elif [ "$1" == "--down" ]; then
        strSearch='caffeine64.exe'
        strLen=${#strSearch}
        strTask=`tasklist | grep "$strSearch"`
        (( i = 0 ))
        (( n = 0 ))
        while [[ ${strTask:$strLen+$i:1} == " " ]];
        do
            (( i++ ))
        done
        (( n = $strLen - 1 + $i / 4 ))
        if [ "$2" == "" ]; then
           ntask=`tasklist | grep "caffeine64.exe" | cut -d ' ' -f $n` 
        else
            ntask=$2
        fi
        taskkill -f //PID $ntask
    elif [ "$1" == "--status" ]; then
        strSearch='caffeine64.exe'
        strLen=${#strSearch}
        strTask=`tasklist | grep "$strSearch"`
        echo $strTask
    else
        echo 'please specify "--up",  "--down" or "--status"'
    fi
}