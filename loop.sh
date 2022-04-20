function loop (){
    out=''
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]]; then
        n=$2
        text=$1
    else
        n=$1
        text=$2
    fi
    for (( i=0; i<$n; i++ ))
        do
        out=$out$text
    done
    `echo $out | clip.exe`
    echo $out" has been copied to the clipboard"
}