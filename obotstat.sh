function obotstat(){
    ti=$1
    px0=$2
    pxi=$3
    px1=$4
    echo "ti="$1" px0="$2" pxi="$3" pxn="$4
    awk "BEGIN{ print $ti*($px1-$px0)/($pxi-$px0) }" ;
}