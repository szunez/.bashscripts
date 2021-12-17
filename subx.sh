function subx() {
    oldStr=$1
    mod0=$2
    mod1=$3
    newStr=''
    if [ "${mod0:0:2}" == "++" ]; then
        newChar=${mod0:2:${#mod0}}
        oldChar=${mod1:2:${#mod1}}
    elif [ "${mod1:0:2}" == "++" ]; then
        newChar=${mod1:2:${#mod1}}
        oldChar=${mod0:2:${#mod0}}
    elif [ "${#mod1}" == 0 ]; then 
        newChar=''
        oldChar=${mod0:2:${#mod0}}
    else
        echo 'Please define the replacement string with a preceding "++" modifier and the superseded string with a preceding "--" modifier'
        echo 'example: > subx original_string ++'\''~'\'' --_'
        echo '         > new~string>output'
        return
    fi
    for (( i=0; i<=${#oldStr}; i++ )) do
        if [ "${oldStr:$i:${#oldChar}}" == "$oldChar" ]; then
            newStr=$newStr$newChar
            ((i=i+${#oldChar}-1))
        else
            newStr=$newStr${oldStr:$i:1}
        fi
    done
    echo $newStr
    echo 'is now available in your clipboard to paste with "ctrl+v" / "shift+insert"'
    `echo $newStr | clip.exe`
}
