#!/bin/bash
########################################################################
#
#                            SO - Trabalho 1
#                   Estatística de Processos em bash
#
# Este script permite a visualização da quantidade de memória total e da
# memória residente em memória física, do número total de bytes I/O,e da
# e taxa de leitura/escrita (bytes/sec) dos processos seleccionados nos
# últimos s segundos.
#
# Pedro Sobral, nMec: 98491
# Daniel Figueireo, nMec: 98498
#
# #######################################################################



function rates(){
    
    rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')
    wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )
    sleep .1
    rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9' )
    wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9' )
    rateR=$(echo "($rchar2-$rchar1)/0.1" | bc -l)
    rateW=$(echo "($wchar2-$wchar1)/0.1" | bc -l)
}


function listarProcessos(){
    for entry in /proc/*; do
        printf "%s %10s %10s %10s %10s %10s %10s %10s %10s %15s\n" "COMM" "USER" "PID" "MEM" "RSS" "READB" "WRITEB" "RATER" "RATEW" "DATE"
        
        PID=$(cat $entry/status | grep -w Pid | tr -dc '0-9')
        user=$(ps -o user= -p $PID)
        startDate=$(ps -o lstart= -p $PID)
        startDate=$(date +"%b %d %H:%M" -d "$startDate")
        
        if [ -f $entry/status ]; then
            VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')
            VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')
            if [ -x $entry ]; then
                rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')
                wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                sleep 0.5
                rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9' )
                wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                rateR=$(echo "($rchar2-$rchar1)/0.5" | bc -l)
                rateW=$(echo "($wchar2-$wchar1)/0.5" | bc -l)
                
            fi
        fi
        #comm=$(cat $entry/comm)
        printf "%15s %10d %10d %10d %10d %10d %10.1f %10.1f \n" $user $PID $VmSize $VmRss $rchar1 $wchar1 $rateR $rateW #$startDate #$comm
        echo "============================================================================================================"
    done
}
listarProcessos



#template de como fazer um menu/aquilo dos -m -t -d -q -r ...
#function menu() {
#
#    if [[ -v argOpt[n] ]]; then
#        # ordenar por numero de sessoes
#        printf "%s\n" "${userInfo[@]}" | sort -k2,2 ${order}
#    else
#        #ordem crescente (nome user)
#        printf "%s\n" "${userInfo[@]}" | sort -k1,1 ${order}
#    fi
#}