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
    elif [ "$1" == "--elm-meeting" ]; then
        cd "$funnelDir"/meetings;
        > `date +%Y%m%d`'-'$2'-elm-notes.txt';
        getElmNotesTemplate $2 ./`date +%Y%m%d`'-'$2'-elm-notes.txt'
        code ./`date +%Y%m%d`'-'$2'-elm-notes.txt'
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
    elif [ "$1" == "--project" ]; then
        mkdir /p/"$2"
        7z x /p/TMPL\ -\ Project\ Directory\ Flow\ Assurance.zip -o/p/"$2"
        cd /p/"$2"
        mv ./TMPL\ -\ Project\ Directory\ Flow\ Assurance/* .
        rm -rf ./TMPL\ -\ Project\ Directory\ Flow\ Assurance
        cp $USERPROFILE/Evoleap\,\ LLC/Consulting\ -\ Documents/6\ Templates/05\ Project\ OneNote/TMPL\ -\ Consulting\ Project\ OneNote\ rev\ B.onepkg /p/"$2"/1\ Admin/
    else
        echo 'Please specify a --demo, --license, --sale, --earlysale, --client, --meeting, etc.'
    fi
}
function getNotesTemplate() {
    printf "%s %s\n%s\n        \n%s\n        \n%s\n        \n%s\n        " `date +%Y%m%d` $1 "    attendees" "    topics" "    questions" "    actionItems" >> $2
}
function getElmNotesTemplate() {
    printf "%s %s\n%s\n        \n%s        \n%s            \n%s            \n%s            \n%s\n            \n%s            \n%s\n            \n%s\n            \n%s\n            \n%s\n        \n%s        \n%s        \n%s        \n%s\n    \n%s\n        \n%s        \n%s        \n%s        \n%s        \n%s        \n%s        \n%s\n        \n%s        \n    \n%s\n        " `date +%Y%m%d` $1 "    attendees" "      topics" "        Intro" "            [ufa] I understood that you have 30min. We want to respect that, so we will wrap up right at 30min unless you want to go over time more." "            We wanted to understand your objectives in this meeting.  Could you please give us a quick high level summary of your main goal today?" "            Our objective is to introduce the elm technology and learn if there may be a match with your project. If there is still interest at the end of the meeting we would like to schedule a demo or connect you with one of our senior developers to answer questions in-depth." "            [s] Can you share some details about the project you were interested in using elm on?" "            Where does this project sit among your priorities?" "            [p] Can you describe some challenges/problems that you have been facing?" "            [i] Can you share what the implications of the challenges you described are for your company and this project?" "            [n] What are some of the expected benefits that you would hope to get from elm?" "        Access management:" "        Account management:" "        Product management:" "        Best practises / scale-up:" "    questions" "        Company:" "        Company age/history:" "        Other solutions in consideration:" "        Role:" "        Products:" "        Industry:" "        Customer base:" "        Problems        |       Trigger" "    actionItems" >> $2
}