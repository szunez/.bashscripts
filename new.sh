function new() {
    if [ "$1" == "--demo" ]; then
        cd "$funnelDir"/meetings
        cp "$salesKitDir"/flotools/CCCC-template/yyymmdd-cccc-demo-notes.txt ./`date +%Y%m%d`'-'$2'-demo-notes.txt';
    elif [ "$1" == "--license" ]; then
        cp "$salesKitDir"/yyyymmdd-licenseRequest.xlsx ./`date +%Y%m%d`'-''licenseRequest'$2'.xlsx';
    elif [ "$1" == "--client" ]; then
        mkdir "$oneDocs"/bd/deals/$2;
        cd "$oneDocs"/bd/deals/$2;
        mkdir 'meetings';
    elif [ "$1" == "--meeting" ]; then
        cd "$funnelDir"/meetings;
        > `date +%Y%m%d`'-'$2'-notes.txt';
        getNotesTemplate $2 ./`date +%Y%m%d`'-'$2'-notes.txt'
        code ./`date +%Y%m%d`'-'$2'-notes.txt'
        explorer .;
    elif [ "$1" == "--sale" ]; then
        gosales
        nproject=`getNumber`
        project=$nproject' '$2
        if [ "$3" == "" ]; then
            product='flotools'
            mkdir "$project - $product"
            if [ "$4" != "" ]; then
                UU=$4
            elif [ "$3" != "" ] && [ "${UU+xxx}" == "xxx" ]; then
                UU=$3
            else
                UU=1
            fi
            if [ "$3" == "--concurrent" ]; then
                cp "$salesKitDir"/flotools/CCCC-template/"000NNN-0 CCCC - flotools UU perpetual concurrent license.docx" ./"$project"\ -\ flotools/"$nproject-0 $2 - flotools $UU perpetual concurrent license.docx"
            else
                cp "$salesKitDir"/flotools/CCCC-template//"000NNN-0 CCCC - flotools UU perpetual named license.docx" ./"$project"\ -\ flotools/"$nproject-0 $2 - flotools $UU perpetual named license.docx"
            fi
        elif [ "$3" != "" ]; then
            product=$3
            mkdir "$project - $product"
        fi
    elif [ "$1" == "--earlysale" ]; then
        gosales
        cd early\ stage
        project=`date +%Y`'-'`date +%m`'-'`date +%d`' '$2
        mkdir "$project"
    else
        echo 'Please specify a --demo, --license, --sale, --earlysale, --client, --meeting, etc.'
    fi
}
function getNotesTemplate() {
    printf "%s %s\n%s\n        \n%s\n        \n%s\n        \n%s\n        " `date +%Y%m%d` $1 "    attendees" "    topics" "    questions" "    actionItems" >> $2
}