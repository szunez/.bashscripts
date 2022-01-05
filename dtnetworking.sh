function dtnetworking () {
    (( week1 = `date +%U -d $1` ))
    (( week0 = `date +%U -d $2` ))
    (( weekday1 = `date +%u -d $1` ))
    (( weekday0 = `date +%u -d $2` ))
    if (( `date +%Y -d $1` > `date +%Y -d $2` )); then
        year0=`date +%Y -d $2`
        (( weekOffset1 = $week1 + `date +%U -d "$year0-12-31"` ))
    else
        weekOffset1=$week1
    fi
    (( dtnethours = ($weekOffset1-$week0)*40 + ($weekday1-$weekday0+1)*8 ))
    echo $dtnethours
}