function getNumber() {
    last=`ls | sort -n |tail -n1 | cut -c -6`
    next=`expr $last + 1`
    if [ $(($next)) -lt 10 ]; then
        echo '00000'$next
    elif [ $(($next)) -lt 100 ]; then
        echo '0000'$next
    elif [ $(($next)) -lt 1000 ]; then
        echo '000'$next
    elif [ $(($next)) -lt 10000 ]; then
        echo '00'$next
    elif [ $(($next)) -lt 10000 ]; then
        echo '0'$next
    else
        echo $next
    fi
}
