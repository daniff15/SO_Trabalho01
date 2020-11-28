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
#########################################################################


# O QUE FALTA
#
# FALTA AS OPÇOES QUE TEM ARGUMENTOS 
#
# FALTA IR VER COMO SE VAI BUSCAR O ULTIMO ARG PASSADO PARA DOS SEC DOS RATES
#
# METER A FUNCAO OPCOES BONITA E APRESENTAVEL
#
#
#

#Arrays
declare -A arrayAss=() # Array Associativo: está guardado a informação de cada processo, sendo a 'key' o PID
declare -A argOpt=() # Array Associativo: está guardada a informação das opções passadas como argumentos na chamada da função


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

#Tratamentos das opçoes passadas como argumentos

while getopts "c:u:rs:e:dmtwp:" option; do
    
    case $option in
        c) #Seleção de processos a utilizar atravez de uma expressão regular
            #echo "-c was triggered! Parameter: $OPTARG"
            if [ ${OPTARG:0:1} == "-" ]; then
                usage
            fi
        ;;
        s) #Seleção de processos a visualizar num periodo temporal - data mínima
            #echo "-s was triggered! Parameter: $OPTARG"
            if [ ${OPTARG:0:1} == "-" ]; then
                usage
            fi
        ;;
        e) #Seleção de processos a visualizar num periodo temporal - data máxima
            #echo "-e was triggered! Parameter: $OPTARG"
            if [ ${OPTARG:0:1} == "-" ]; then
                usage
            fi
        ;;
        u) #Seleção de processos a visualizar através do nome do utilizador
            #echo "-u was triggered! Parameter: $OPTARG"
            if [ ${OPTARG:0:1} == "-" ]; then
                usage
            fi
        ;;
        p) #Número de processos a visualizar
            #echo "-p was triggered! Parameter: $OPTARG"
            if [ ${OPTARG:0:1} == "-" ]; then
                usage
            fi
        ;;
        m) #Ordenação da tabela por MEM (decrescente)
        ;;
        t) #Ordenação da tabela por RSS (decrescente)
            
        ;;
        d) #Ordenação da tabela por RATER (decrescente)
            
        ;;
        w) #Ordenação da tabela pOR RATEW (decrescente)
            
        ;;
        r) #Ordenação reversa
            
        ;;
        *) #Passagem de argumentos inválidos
            opcoes
            exit
        ;;
    esac
    
    if [[ -z "$OPTARG" ]]; then
        argOpt[$option]="none"
    else
        argOpt[$option]=${OPTARG}
    fi
done

# NAO SEI OQ ISTO FAZ
#shift $((OPTIND - 1))


#Tratamento dos dados lidos
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
            
            #nao sei se este if faz sentido
            if [[ VmSize -ne 0 || VmRss -ne 0 ]]; then
                if [ -f $entry/status ]; then
                    sec=$1
                    rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')         #rchar inicial
                    wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9' )        #wchar inicial
                    sleep $sec                                                    #tempo em espera
                    rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9' )        #rchar apos s segundos
                    wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9' )        #wchar apos s segundos
                    rateR=$(echo "($rchar2-$rchar1)/$sec" | bc )                  #calculo do rateR
                    rateW=$(echo "($wchar2-$wchar1)/$sec" | bc )                  #calculo do rateW
                    #rateR=0
                    #rateW=0
                    
                fi
                comm=$(cat $entry/comm)
                
                #fizemos arrayAss[$PID] pelo $PID, pq cada processo tem um diferente, e é uma boa maniera de os distinguir visto que assim não há colisão de informação
                arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW"  "$startDate");
            fi
        fi
    done
    
    prints
}


function prints(){
    
    if [[ -v argOpt[r] ]]; then
        ordem="-n"
    else
        ordem="-rn"
    fi
    
    if [[ -v argOpt[m] ]]; then
        #Ordenação da tabela pelo MEM
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k4
        
    elif [[ -v argOpt[t] ]]; then
        #Ordenação da tabela prlo RSS
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k5
        
    elif [[ -v argOpt[d] ]]; then
        #Ordenação da tabela pelo RATER
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k8
        
    elif [[ -v argOpt[w] ]]; then
        #Ordenação da tabela pelo RATEW
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k9
        
    else
        #Ordenação default da tabela, ordem alfabética dos processos
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k1
        
    fi

}

listarProcessos ${@: -1}

