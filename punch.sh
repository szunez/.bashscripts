function punch() {
    utcTime=`date +%s`
    (( SECONDS = $utcTime ))
    echo 'report @UTC='$SECONDS' | '`date +%H:%M:%S`
    if [ "$1" == "--in" ] || [ "$1" == "-i" ]; then
        #echo $SECONDS',"'`date +%"Y-%m-%d %H:%M"`'",in,'$2 >> ~/time.log
        sed -i "1s/^/$SECONDS,\"`date +%"Y-%m-%d %H:%M"`\",in,$2\n/" ~/time.log
    elif [ "$1" == "--out" ] || [ "$1" == "-o" ]; then
        lastTime=`echo $( head -n 1 ~/time.log ) | cut -f1 -d','`
        delaTime=`printf %.2f "$((10**3 * ($SECONDS-$lastTime)/3600))e-3"`
        #echo $SECONDS',"'`date +%"Y-%m-%d %H:%M"`'",out,'$2','$delaTime' hours,'>> ~/time.log
        sed -i "1s/^/$SECONDS,\"`date +%"Y-%m-%d %H:%M"`\",out,$2,$delaTime hours,\n/" ~/time.log
    elif [ "$1" == "--summary" ] || [ "$1" == "-s" ]; then
        lines=`wc -l ~/time.log | cut -f1 -d' '`
        if [ "$2" == "" ]; then
            (( days = 43200 ))
        else
            (( days = $2*86400 ))
        fi
        curTime=$SECONDS
        (( startTime = $curTime - $days ))
        lastTime=`echo $( tail -n $lines ~/time.log ) | cut -f1 -d','`
        task=()
        dur=()
        (( i = 0 ))
        until [ "$startTime" -gt "$lastTime" ]; do            
            (( line = $lines - $i + 1 ))
            (( nextLine = $line - 1 ))       
            lastTime=`echo $( tail -n $nextLine ~/time.log ) | cut -f1 -d','`
            if [ "$i" -gt "$lines" ]; then
                break
            fi
            if [ "`echo $( tail -n $line ~/time.log ) | cut -f3 -d','`" == "out" ]; then
                task[$i]=`echo $( tail -n $line ~/time.log ) | cut -f4 -d','`
                dur[$i]=`echo $( tail -n $line ~/time.log ) | cut -f5 -d',' | cut -f1 -d' '`
            fi
            (( i++ ))
        done
        taskSummary=(`echo ${task[@]} | xargs -n1 | sort -u | xargs`)
        durSummary=()
        durTotal=""
        (( taskLimit = ${#task[@]}*2 ))
        echo ''
        echo '──────────┬──────────────────────'
        echo ' duration │   task'
        echo '[ hours ] │ description'
        echo '──────────┼──────────────────────'
        for (( k=0; k<${#taskSummary[@]}; k++ )) do
            for (( j=0; j<=$taskLimit; j++ )) do 
                if [ "${task[$j]}" == "${taskSummary[$k]}" ]; then
                    durSummary[$k]=$(awk '{print $1+$2}' <<<"${dur[$j]} ${durSummary[$k]}")
                fi
            done
        durTotal=$(awk '{print $1+$2}' <<<"$durTotal ${durSummary[$k]}")
        padding0='       '
        printf "%s%s │ %s\n" '  '${durSummary[$k]} "${padding0:${#durSummary[$k]}}" '  '${taskSummary[$k]}
        done
        echo '══════════╦══════════════════════'
        printf "%s%s ║ %s\n" '  '$durTotal "${padding0:${#durTotal}}" '  '"period total"
    elif [ "$1" == "--edit" ] || [ "$1" == "-e" ]; then
        getTimelog
    fi
}