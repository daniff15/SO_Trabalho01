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
para fazer o raterw e o rater
rchar1=$(cat /proc/$$/io | grep rchar | tr -dc '0-9' )
wchar1=$(cat /proc/$$/io | grep wchar | tr -dc '0-9' )
sleep .5
rchar2=$(cat /proc/$$/io | grep rchar | tr -dc '0-9' )
wchar2=$(cat /proc/$$/io | grep wchar | tr -dc '0-9' )
rateR=$(echo "$rchar2/$rchar1" | bc -l)
rateW=$(echo "$wchar2/$wchar1" | bc -l)
echo "$rateR"
echo "$rateW"
}


function listarProcessos(){
printf "%s %10s %10s %10s %10s\n" "VMSIZE" "VMRSS" "RCHAR" "WCHAR" "COMM"
for entry in /proc/*; do
    if [ -d $entry ]; then
        VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')
        VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')
        if [ -x $entry ]; then
            rchar=$(cat $entry/io | grep rchar | tr -dc '0-9')
            wchar=$(cat $entry/io | grep wchar | tr -dc '0-9' )
        fi
    fi
        comm=$(cat $entry/comm)
        printf "%d %10d %10d %10d %10s\n" $VmSize $VmRss $rchar $wchar $comm
        echo "========================================================================"
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