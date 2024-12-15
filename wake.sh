function wake() {
    if [ "$1" == "--up" ]; then
        # '/c/Program\ Files/Caffeine/caffeine.exe' & echo 'caffeine.exe is up'
        /c/Program\ Files/Caffeine/caffeine.exe & echo 'caffeine.exe is up'
    elif [ "$1" == "--down" ]; then
        strSearch='caffeine.exe'
        strLen=${#strSearch}
        strTask=`tasklist | grep "$strSearch"`
        (( i = 0 ))
        (( n = 0 ))
        while [[ ${strTask:$strLen+$i:1} == " " ]];
            do
                (( i++ ))
            done
        (( n = i + 1 ))
        # (( n = $strLen - 1 + $i / 4 ))
        if [ "$2" == "" ]; then
           ntask=`tasklist | grep $strSearch | cut -d ' ' -f $n` 
        else
            ntask=$2
        fi
        taskkill -f //PID $ntask
    elif [ "$1" == "--status" ]; then
        strSearch='caffeine.exe'
        strLen=${#strSearch}
        strTask=`tasklist | grep "$strSearch"`
        echo $strTask
    else
        echo 'please specify "--up",  "--down" or "--status"'
    fi
}