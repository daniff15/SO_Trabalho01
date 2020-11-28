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


## Se estiver com pAtXORa, ir ver como por o header fixo

## NAO SEI ATE QUE PONTO ISTO É UTIL/FUNCIONAL
function opcoes(){
    echo "
    ************************************************************************************************

    OPÇÃO INVÁLIDA!

    -c          : search for users that has regex OPTION
	-u          : seacrh for users that belongs to group OPTION
	-r          : command last retrieves information from the FILE
	-s          : shows sessions after DATE
	-e          : show sessions before DATE
	-d	        : reverse order
	-d	        : sorts the sessions by number of sessions
	-m	        : sorts the sessions by time
	-t	        : sorts the sessions by max time
	-w	        : sorts the sessions by min time
    -p          :

    ************************************************************************************************"
}

declare -A arrayAss=() # Array Associativo  

function listarProcessos(){
    #Cabeçalho
    printf "%-30s %-16s %15s %12s %12s %12s %12s %12s %12s %16s\n" "COMM" "USER" "PID" "MEM" "RSS" "READB" "WRITEB" "RATER" "RATEW" "DATE"
    for entry in /proc/*; do
        if [[ -f $entry/comm ]]; then
            PID=$(cat $entry/status | grep -w Pid | tr -dc '0-9')               #ir buscar o PID
            user=$(ps -o user= -p $PID)                                         #ir buscar o user do PID
            startDate=$(ps -o lstart= -p $PID)                                  #data de início do processo atraves do PID
            startDate=$(date +"%b %d %H:%M" -d "$startDate")                    #formatação da data conforme o guião
            
            VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')        
            VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')
            
            if [[ VmSize -ne 0 || VmRss -ne 0 ]]; then
                if [ -f $entry/status ]; then
                    
                    rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')         #rchar inicial
                    wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )        #wchar inicial
                    sleep $1                                                    #tempo em espera
                    rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9' )        #rchar apos s segundos
                    wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9' )        #wchar apos s segundos
                    rateR=$(echo "($rchar2-$rchar1)/$1" | bc )                  #calculo do rateR
                    rateW=$(echo "($wchar2-$wchar1)/$1" | bc )                  #calculo do rateW
                    
                fi
                comm=$(cat $entry/comm)

                #fizemos arrayAss[$PID] pelo $PID, pq cada processo tem um diferente, e é uma boa maniera de os distinguir visto que assim não há colisão de informação
                arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW"  "$startDate");

            fi
        fi
    done
    
    printf '%s \n' "${arrayAss[@]}" | sort -n -k1                               #-n sort crescente -rn sort decrescente -k'?' para ordenar por essa ordem (-rn ou -n) a coluna '?'
    
}

if [[ $# == 1 ]]; then
        listarProcessos $1
    fi

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
        *)
            opcoes
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