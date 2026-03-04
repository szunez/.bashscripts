#!/bin/bash
function mkSps() {
    mkdir '1 Admin'
    mkdir '1 Admin/OneNote'
    mkdir '2 Client data'
    mkdir '3 Calculations'
    mkdir '4 Simulations'
    mkdir '4 Simulations/Rev1'
    mkdir '4 Simulations/Rev1/_base'
    mkdir '4 Simulations/Rev1/_base/_dummy'
    mkdir '4 Simulations/Rev1/ark'
    mkdir '4 Simulations/Rev1/dsp'
    mkdir '4 Simulations/Rev1/dspx'
    mkdir '4 Simulations/Rev1/inc'
    mkdir '4 Simulations/Rev1/simp'
    mkdir '4 Simulations/Rev1/steady state'
    mkdir '4 Simulations/Rev1/svwx'
    mkdir '4 Simulations/Rev1/transients'
    mkdir '5 Workspaces'
    mkdir '6 Deliverables'
}
function sps-help (){
    msedge.exe /c/Program\ Files\ \(x86\)/DNVGL/SPS\ 10.7/bin/Help/HTML/SPS/Default.htm &
}
function mk-flotools-headers() {
    cd ../4\ Simulations/Rev1/simp
    sed -i -E '
      1,2 {
        s# , #[ min ],#g
        s#PSIG,#[ psig ],#g
        s#PSI,#[ psig ],#g
        s#AB/HR,#[ bbl/h ],#g
        s#B/HR,#[ bbl/h ],#g
        s#LBM/S,#[ lb/s ],#g
        s#FR,#[ fraction ],#g
        s#, PSI\n#, [ psi ]\n#g
      }
    ' ./*.csv
}
function get-data() {
    project="../4\ Simulations/Rev1"
    scenario="transients"
    cd $project/$scenario
    mode="directory"
    if [[ $1 == "" ]]; then
        vSPS="10.7"
    else
        vSPS=$1
    fi
    for arg in "$@"; do
        if [[ "$prev" == "-d" ]]; then
            folders="$arg"
            mode="single"
        fi
        prev="$arg"
    done
    if [[ $mode == "directory" ]]; then
        folders=($(find . -maxdepth 1 -type d -not -path . -printf '%P\n' | sort))
    fi
    for case in ${folders[@]}; do 
        echo "Getting data for $case"
        /c/Program\ Files\ \(x86\)/DNVGL/SPS\ $vSPS/bin/DREVIEW ./$case/$case.review "-match=(T.ROME_RCV:P* T.ROME100:P* T.ROME200:P* T.ROME300:P* T.ROME408:P* B.MOV44*:P* B.MOV2117*:P* B.SDV*:P* B.MOVR*:P* B.FCVR*:P* B.MOV44*:Q* B.MOV2117*:Q* B.SDV*:Q* B.MOVR*:Q* B.FCVR*:Q* B.MOV44*FR B.MOV2117*:FR B.SDV*:FR B.MOVR*:FR B.FCVR*:FR)" > ../simp/${case}_dreview.csv
    done
}