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




#if [ $1 == "a"]; then
#    cat /proc/$$/status | grep VmSize
#    cat /proc/$$/status | grep VmRSS
#    cat /proc/$$/io | grep rchar
#    cat /proc/$$/io | grep wchar
#    cat /proc/$$/comm
#    # Para o alias correr, tem de se correr assim: 'source procstat.sh a'
#    alias pss='ps -A --format comm,pid,ppid,pgid,sid'
#    pss
#else
#    echo "Deu merda zé"
#fi


# para fazer o raterw e o rater
#ola=$(cat /proc/$$/io | grep rchar | tr -dc '0-9' )
#echo $ola
#sleep 3
#adeus=$(cat /proc/$$/io | grep rchar | tr -dc '0-9') 
#echo $adeus

for entry in /proc/*; do
printf "%s %10s %10s %10s %10s\n" "VMSIZE" "VMRSS" "RCHAR" "WCHAR" "COMM" 
    VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')
    VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')
    rchar=$(cat $entry/io | grep rchar | tr -dc '0-9')
    wchar=$(cat $entry/io | grep wchar | tr -dc '0-9' )
    comm=$(cat $entry/comm)
    printf "%d %10d %10d %10d %10s\n" $VmSize $VmRss $rchar $wchar $comm

    echo "---------------------------------------------"
done
    




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
