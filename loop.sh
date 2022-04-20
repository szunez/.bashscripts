function loop (){
    out=''
    if ! [[ "$1" =~ "^[0-9]+([.][0-9]+)?$" ]]; then
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
}