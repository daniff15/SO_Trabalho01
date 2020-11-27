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



# let's be intelegents and do some function, coz doing always comments its boring and wastefull

function rates(){

    ##
    ## Isto esta mal, a conta é (rchar2 - rchar1) / sec
    ##
    rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')
    wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )
    sleep 1
    rchar2=$(cat /proc/$entry/io | grep rchar | tr -dc '0-9' )
    wchar2=$(cat /proc/$entry/io | grep wchar | tr -dc '0-9' )
    rateR=$(echo "$rchar2/$1" | bc -l)
    rateW=$(echo "$wchar2/$2" | bc -l)
}


function listarProcessos(){
    for entry in /proc/*; do
        printf "%s %10s %10s %10s %10s %10s %10s %10s \n" "COMM" "USER" "VMSIZE" "VMRSS" "RCHAR" "WCHAR" "RATER" "RATEW"

        PID=$(cat $entry/status | grep Pid)
        echo $PID
        #ps -o user= -p PID
        if [ -f $entry/status ]; then
            VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')
            VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')
            if [ -x $entry ]; then
                rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')
                wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                #sleep .1
                #rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9' )
                #wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                #rateR=$(echo "$rchar2/$rchar1" | bc -l)
                #rateW=$(echo "$wchar2/$wchar1" | bc -l)
            fi
        fi
        #comm=$(cat $entry/comm)
        printf "%15s %10d %10d %10d %10d\n" $user $VmSize $VmRss $rchar1 $wchar1 #$rateR #$rateW #$comm
        echo "=================================================================================="
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