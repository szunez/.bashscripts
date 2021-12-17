function unixit() {
    newStr=""
    oldStr=$1
    if [ "${oldStr:0:3}" == 'C:\' ]; then
        oldStr='/c/'${oldStr:3:${#oldStr}}
    fi
    for (( i=0; i<=${#oldStr}; i++ )) do
        if [ "${oldStr:$i:1}" == " " ]; then
            newStr=$newStr'\ '
        elif [ "${oldStr:$i:1}" == '\' ]; then
            newStr=$newStr'/'
        else
            newStr=$newStr${oldStr:$i:1}
        fi
    done
    #`echo "$1" | sed -e "s;"\\";"\/";g" | sed -e "s;"C\:";"\/c";" | clip.exe`
    `echo $newStr | clip.exe`
    echo ""
    echo 'The following text is now available in your clipboard to paste with "ctrl+v" or "shift+insert":'
    echo ""
    echo "  >"$newStr
}
