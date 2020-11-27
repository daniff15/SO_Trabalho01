#!/bin/bash
########################################################################
#
#                            SO - Trabalho 1
#                   Estatística de Processos em bash
#
# Este script permite a visualização da quantidade de memória total e da
# memória residente em memória física, do número total de bytes I/O,e da
# e taxa de leitura/escrita (bytes/sec) dos processos seleccionados nos
# últimos sec segundos.
#
# Pedro Sobral, nMec: 98491
# Daniel Figueireo, nMec: 98498
#
# #######################################################################

##
##
## Se estiver com pAtXORa, ir ver como por o header fixo
##
##
##


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
    printf "%-30s %-10s %15s %12s %12s %12s %12s %12s %12s %16s\n" "COMM" "USER" "PID" "MEM" "RSS" "READB" "WRITEB" "RATER" "RATEW" "DATE"
    for entry in /proc/*; do
        if [[ -f $entry/comm ]]; then
            PID=$(cat $entry/status | grep -w Pid | tr -dc '0-9')
            user=$(ps -o user= -p $PID)
            startDate=$(ps -o lstart= -p $PID)                                  #data de início do processo atraves do PID
            startDate=$(date +"%b %d %H:%M" -d "$startDate")                    #formatação da data conforme o guião
            
            VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')
            VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')
            if [[ VmSize -ne 0 || VmRss -ne 0 ]]; then
                if [ -f $entry/status ]; then
                    
                    rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')
                    wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                    sleep 2
                    rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9' )
                    wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                    rateR=$(echo "($rchar2-$rchar1)/2" | bc )
                    rateW=$(echo "($wchar2-$wchar1)/2" | bc )
                    #rateR e rateW = 0, para isto correr e n chatear
                    #rateR=0
                    #rateW=0
                    
                fi
                comm=$(cat $entry/comm)
            printf "%-30s %-10s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" $user $PID $VmSize $VmRss $rchar1 $wchar1 $rateR $rateW  "$startDate"
            fi
        fi
    done
}
listarProcessos


while getopts "c:u:rs:e:dmtwp:" opt; do
    case $opt in
        c)
            echo "-c was triggered! Parameter: $OPTARG"
        ;;
        s)
            echo "-s was triggered! Parameter: $OPTARG"
        ;;
        e)
            echo "-e was triggered! Parameter: $OPTARG"
        ;;
        u)
            echo "-u was triggered! Parameter: $OPTARG"
        ;;
        p)
            echo "-p was triggered! Parameter: $OPTARG"
        ;;
        m)
            echo "-b was triggered!"
        ;;
        t)
            echo "-b was triggered!"
        ;;
        d)
            echo "-b was triggered!"
        ;;
        w)
            echo "-b was triggered!"
        ;;
        r)
            echo "-b was triggered!"
        ;;
        \?)
            echo "Invalid option: -$OPTARG"
        ;;
    esac
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