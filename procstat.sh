#!/bin/bash
#########################################################################################################################
#
#                                                    SO - Trabalho 1
#                                           Estatística de Processos em bash
#
# Este script permite a visualização da quantidade de memória total e da memória residente em memória física, do número 
# total de bytes I/O,e da e taxa de leitura/escrita (bytes/sec) dos processos seleccionados nos últimos sec segundos.
#
# Pedro Sobral, nMec: 98491
# Daniel Figueireo, nMec: 98498
#
#########################################################################################################################



#Arrays
declare -A arrayAss=() # Array Associativo: está guardado a informação de cada processo, sendo a 'key' o PID
declare -A argOpt=()   # Array Associativo: está guardada a informação das opções passadas como argumentos na chamada da função #fizemos arrayAss[$PID] pelo $PID, pq cada processo tem um diferente, e é uma boa maniera de os distinguir visto que assim não há colisão de informação
i=0                    #iniciação da variável i, usada na condição do argOpt[p]

function opcoes() {
    echo "************************************************************************************************"
    echo "OPÇÃO INVÁLIDA!"
    echo "    -c        : Seleção de processos a utilizar atravez de uma expressão regular"
    echo "    -u        : Seleção de processos a visualizar através do nome do utilizador"
    echo "    -r        : Ordenação reversa"
    echo "    -s        : Seleção de processos a visualizar num periodo temporal - data mínima"
    echo "    -e        : Seleção de processos a visualizar num periodo temporal - data máxima"
    echo "    -d	      : Ordenação da tabela por RATER (decrescente)"
    echo "    -m	      : Ordenação da tabela por MEM (decrescente)"
    echo "    -t	      : Ordenação da tabela por RSS (decrescente)"
    echo "    -w        : Ordenação da tabela pOR RATEW (decrescente)"
    echo "    -p        : Número de processos a visualizar"
    echo "************************************************************************************************"
}

#Tratamentos das opçoes passadas como argumentos

while getopts "c:u:rs:e:dmtwp:" option; do

    case $option in
    c) #Seleção de processos a utilizar atraves de uma expressão regular
        #echo "-c was triggered! Parameter: $OPTARG"

        ;;
    s) #Seleção de processos a visualizar num periodo temporal - data mínima
        #echo "-s was triggered! Parameter: $OPTARG"
        ;;
    e) #Seleção de processos a visualizar num periodo temporal - data máxima
        #echo "-e was triggered! Parameter: $OPTARG"
        ;;
    u) #Seleção de processos a visualizar através do nome do utilizador
        #echo "-u was triggered! Parameter: $OPTARG"
        ;;
    p) #Número de processos a visualizar
        #echo "-p was triggered! Parameter: $OPTARG"
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


#Tratamento dos dados lidos
function listarProcessos() {
    #Cabeçalho
    printf "%-30s %-16s %15s %12s %12s %12s %12s %12s %12s %16s\n" "COMM" "USER" "PID" "MEM" "RSS" "READB" "WRITEB" "RATER" "RATEW" "DATE"
    for entry in /proc/*; do
        if [[ -f $entry/comm ]]; then
            PID=$(cat $entry/status | grep -w Pid | tr -dc '0-9')           # ir buscar o PID
            user=$(ps -o user= -p $PID)                                     # ir buscar o user do PID
            startDate=$(ps -o lstart= -p $PID)                              # data de início do processo atraves do PID
            startDate=$(date +"%b %d %H:%M" -d "$startDate")                # formatação da data conforme o guião

            VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9')
            VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')

            #nao sei se este if faz sentido
            if [[ VmSize -ne 0 || VmRss -ne 0 ]]; then
                if [ -f $entry/status ]; then
                    sec=$1
                    rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9')     # rchar inicial
                    wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9')     # wchar inicial
                    sleep $sec                                              # tempo em espera
                    rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9')     # rchar apos s segundos
                    wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9')     # wchar apos s segundos
                    rateR=$(echo "($rchar2-$rchar1)/$sec" | bc)             # calculo do rateR
                    rateW=$(echo "($wchar2-$wchar1)/$sec" | bc)             # calculo do rateW

                fi
                comm=$(cat $entry/comm)

                #Seleção de processos a visualizar num periodo temporal
                if [[ -v argOpt[s] && -v argOpt[e] ]]; then

                    start=$(date -d "${argOpt['s']}" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}')  # data mínima
                    end=$(date -d "${argOpt['e']}" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}')    # data máxima
                    dateSeg=$(date -d "$startDate" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}')    # data do processo

                    if [[ $dateSeg < $end && $dateSeg > $start ]]; then
                        arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW" "$startDate")
                    fi
                
                #Seleção de processos a visualizar através do nome do utilizador
                elif [[ -v argOpt[u] ]]; then
                    userMatch="${argOpt['u']}"

                    if [[ $userMatch = $user ]]; then
                        arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW" "$startDate")
                    fi

                #Seleção de processos a utilizar atraves de uma expressão regular
                elif [[ -v argOpt[c] ]]; then

                    if [[ $comm =~ ${argOpt['c']} ]]; then
                        arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW" "$startDate")                        
                    fi

                elif [[ -v argOpt[c] && -v argOpt[p] ]]; then
                    
                    if [[ $comm =~ ${argOpt['c']} && $i < ${argOpt['p']} ]]; then
                        arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW" "$startDate")  
                        let "i=i+1"                      
                    fi

                #Número de processos a visualizar
                elif [[ -v argOpt[p] ]]; then

                    if [[ $i < ${argOpt['p']} ]]; then
                        arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW" "$startDate")                        
                        let "i=i+1"
                    fi

                #Ordenação default da tabela, ordem alfabética dos processos
                else
                    arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW"  "$startDate");
                fi


            fi
        fi

    done

    prints
}

function prints() {

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
        #Como é por ordem alfabética temos de mudar a ordem para '-n'
        ordem="-n"
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k1

    fi

}

listarProcessos ${@: -1}            #este agumento passado é para os segundos, visto que e passado em todas as opções