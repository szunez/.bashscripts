function revit() {
    if [ "$1" == "--help" ] || [ "$1" == "-h" ] ; then
        echo 'Usage: revit [OPTION]number [OPTION]letter filename'
        echo '       number   [--up, -u increments the revision number                    ]'
        echo '                [--down, -d decrements the revision number                  ]'
        echo '                [the default mode is --up                                   ]'
        echo '       letter   [--up, -u increments the revision/option letter             ]'
        echo '                [--down, -d decrements the revision/option letter           ]'
        echo '                [the default behaviour is to ignore the letter              ]'
        echo '       filename [The filemane of the file that is the basis for the revision]'
        return
    fi
    revChar=7
    optChar=0
    opt=''
    rev=''
    if [ "$3" == "" ] && [ "$2" == "" ] ; then
        revDoc0=$1
        revGo='--up'
    elif [ "$3" == "" ] ; then
        revDoc0=$2
        revGo=$1
    else
        revDoc0=$3
        optGo=$2
        revGo=$1
        revChar=7
        optChar=1
        opt0=${revDoc0:revChar+optChar:1}
        opts='abcdefghijklmnopqrstuvwxyz'
        i=0
        if [ "$optGo" == "--down" ] || [ "$optGo" == "-d" ] ; then
            until [ "$opt0" == "${opts:${#opts}-i:1}" ]; do
                (( i++ ))
            done
            opt=${opts:${#opts}-$i-1:1}
        elif [ "$optGo" == "--up" ] || [ "$optGo" == "-u" ] ; then
            until [ "$opt0" == "${opts:i:1}" ]; do
                (( i++ ))
            done
            opt=${opts:$i+1:1}
        else
            echo 'Option indicators can be ['$opts']'
            opt=${2:${#2}-1:1}
            echo 'The option/revision letter will not be updated to '$opt
        fi
    fi
    rev=${revDoc0:$revChar:1}
    if [ "$revGo" == "--down" ] || [ "$revGo" == "-d" ] ; then
        (( rev-- ))
    elif [ "$revGo" == "--up" ] || [ "$revGo" == "-u" ] ; then
        (( rev++ ))
    else
        rev=${1:${#1}-1:1}
        echo 'The revision number will be updated to '$rev
    fi
    revDoc1=${revDoc0:0:$revChar}$rev$opt${revDoc0:$revChar+$optChar+1:${#revDoc0}-$revChar-$optChar-1}
    cp "$revDoc0" "./$revDoc1"
    echo $revDoc1' has been created'
}