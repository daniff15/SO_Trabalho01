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
    printf "%-30s %-10s %15s %12s %12s %12s %12s %12s %12s %12s\n" "COMM" "USER" "PID" "MEM" "RSS" "READB" "WRITEB" "RATER" "RATEW" "DATE"
    for entry in /proc/*; do
        if [[ -f $entry/comm ]]; then
            PID=$(cat $entry/status | grep -w Pid | tr -dc '0-9')
            user=$(ps -o user= -p $PID)
            startDate=$(ps -o lstart= -p $PID)                                  #data de início do processo atraves do PID
            startDate=$(date +"%b %d %H:%M" -d "$startDate")                    #formatação da data conforme o guião
            
            if [ -f $entry/status ]; then
                VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')
                VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')
                if [ -x $entry ]; then
                    rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')
                    wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                    #sleep 0.5
                    rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9' )
                    wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9' )
                    rateR=$(echo "($rchar2-$rchar1)/0.5" | bc -l)
                    rateW=$(echo "($wchar2-$wchar1)/0.5" | bc -l)
                    #rateR e rateW = 0, para isto correr e n chatear
                    rateR=0
                    rateW=0
                    
                fi
            fi
            comm=$(cat $entry/comm)
            printf "%-30s %-10s %15d %12d %12d %12d %12d %12.1f %12.1f \n" $comm $user $PID $VmSize $VmRss $rchar1 $wchar1 $rateR $rateW  #$startDate
        fi
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