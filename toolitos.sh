#!/bin/bash
function calc () { awk "BEGIN{ 
    pi = 3.141592653589793
    e = 2.718281828459045
    print $* }" ;
}
function len () {
    echo ${#1}
}function dt () {
    (( dtime=0 ))
    (( t1 = 0 ))
    if [ "$1" == "-0" ]; then
        t0=`date +%s`
    else
        t1=`date +%s`
        (( dtime = $t1-$t0 ))
        t0=$t1
        echo $dtime
    fi
}
function goPyOcr () {
    if [[ "$1" == "--loop" || "$1" == "-l" ]]; then
        for i in *$2*; do
            python /c/src/py-apps/ocr/pdfocr.py $i
            echo $i
        done
    else
        echo $(python /c/src/py-apps/ocr/pdfocr.py $1)
    fi
}
function cp+ () {
    if [ "$2" == "" ]; then
        preamble=$preamble
    else
        preamble=$2
    fi
    $(echo $preamble', '$1 | clip.exe)
}