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

#
# FAZER AS POSSIBILIDADES DAS OPÇOES COM ARGUMENTO :/
# FAZER IF PRA VER SE TEM PERMISSAO PARA NAO USAR O SUDO
# NA OPCAO COM -c E -p AQUELA MERDA AINDA N DA 100% BEM
#

#Arrays
declare -A arrayAss=() # Array Associativo: está guardado a informação de cada processo, sendo a 'key' o PID
declare -A argOpt=()   # Array Associativo: está guardada a informação das opções passadas como argumentos na chamada da função

i=0 #iniciação da variável i, usada na condição de verificação de opçoes de ordenacao

#Função para quando argumentos passados são inválidos
function opcoes() {
    echo "************************************************************************************************"
    echo "OPÇÃO INVÁLIDA!"
    echo "    -c        : Seleção de processos a utilizar através de uma expressão regular"
    echo "    -u        : Seleção de processos a visualizar através do nome do utilizador"
    echo "    -r        : Ordenação reversa"
    echo "    -s        : Seleção de processos a visualizar num periodo temporal - data mínima"
    echo "    -e        : Seleção de processos a visualizar num periodo temporal - data máxima"
    echo "    -d        : Ordenação da tabela por RATER (decrescente)"
    echo "    -m        : Ordenação da tabela por MEM (decrescente)"
    echo "    -t        : Ordenação da tabela por RSS (decrescente)"
    echo "    -w        : Ordenação da tabela pOR RATEW (decrescente)"
    echo "    -p        : Número de processos a visualizar"
    echo "   Nota       : As opções -d,-m,-t,-w não podem ser utilizadas em simultâneo"
    echo "************************************************************************************************"
}

#Tratamentos das opçoes passadas como argumentos
while getopts "c:u:rs:e:dmtwp:" option; do

    case $option in
    c) #Seleção de processos a utilizar atraves de uma expressão regular

        ;;
    s) #Seleção de processos a visualizar num periodo temporal - data mínima

        ;;
    e) #Seleção de processos a visualizar num periodo temporal - data máxima

        ;;
    u) #Seleção de processos a visualizar através do nome do utilizador

        ;;
    p) #Número de processos a visualizar

        ;;
    r) #Ordenação reversa

        ;;
    m | t | d | w) 
    
    if [[ $i = 1 ]]; then 
        #Quando há mais que 1 argumento de ordenacao
        opcoes
        exit
    else
        #Se algum argumento for de ordenacao i=1
        i=1
    fi
        ;;

    *) #Passagem de argumentos inválidos
    opcoes
    exit
    ;;
    esac

    #Adicionar ao array argOpt as opcoes passadas ao correr o procstat.sh, caso existam adiciona as que são passadas, caso não, adiciona "nada"
    if [[ -z "$OPTARG" ]]; then
        argOpt[$option]="nada"
    else
        argOpt[$option]=${OPTARG}
    fi
done

#Tratamento dos dados lidos
function listarProcessos() {

    #Cabeçalho
    printf "%-30s %-16s %15s %12s %12s %12s %12s %12s %12s %16s\n" "COMM" "USER" "PID" "MEM" "RSS" "READB" "WRITEB" "RATER" "RATEW" "DATE"
    for entry in /proc/[[:digit:]]*; do
        if [[ -r $entry/status && -r $entry/io ]]; then    
            PID=$(cat $entry/status | grep -w Pid | tr -dc '0-9')    # ir buscar o PID
            user=$(ps -o user= -p $PID)                              # ir buscar o user do PID
        
            VmSize=$(cat $entry/status | grep VmSize | tr -dc '0-9') # ir buscar o VmSize
            VmRss=$(cat $entry/status | grep VmRSS | tr -dc '0-9')   # ir buscar o VmRss
            
            comm=$(cat $entry/comm | tr " " "_")                     # ir buscar o comm,e retirar os espaços e substituir por '_' nos comm's com 2 nomes


            #Seleção de processos a visualizar através do nome do utilizador
            if [[ -v argOpt[u] && ! ${argOpt['u']} == $user ]]; then
                continue
            fi

            #Seleção de processos a utilizar atraves de uma expressão regular
            if [[ -v argOpt[c] && ! $comm =~ ${argOpt['c']} ]]; then
                continue
            fi

            LANG=en_us_8859_1
            startDate=$(ps -o lstart= -p $PID)                                            # data de início do processo atraves do PID
            startDate=$(date +"%b %d %H:%M" -d "$startDate")                              # formatação da data conforme o guião
            dateSeg=$(date -d "$startDate" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}') # data do processo em segundos

            start=$(date -d "${argOpt['s']}" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}') # data mínima
            end=$(date -d "${argOpt['e']}" +"%b %d %H:%M"+%s | awk -F '[+]' '{print $2}')   # data máxima

            if [[ -v argOpt[s] && "$dateSeg" -lt "$start" ]]; then #Para a opção -s
                continue
            fi

            if [[ -v argOpt[e] && $dateSeg -gt $end ]]; then #Para a opção -e
                continue
            fi

            rchar1=$(cat $entry/io | grep rchar | tr -dc '0-9') # rchar inicial
            wchar1=$(cat $entry/io | grep wchar | tr -dc '0-9') # wchar inicial
            sleep $1                                            # tempo em espera
            rchar2=$(cat $entry/io | grep rchar | tr -dc '0-9') # rchar apos s segundos
            wchar2=$(cat $entry/io | grep wchar | tr -dc '0-9') # wchar apos s segundos
            rateR=$(echo "($rchar2-$rchar1)/$1" | bc)           # calculo do rateR
            rateW=$(echo "($wchar2-$wchar1)/$1" | bc)           # calculo do rateW

            #Inserir no array associativo as variáveis calculadas, onde o array tem como 'key' o PID
            arrayAss[$PID]=$(printf "%-30s %-16s %15d %12d %12d %12d %12d %12.1f %12.1f %16s\n" "$comm" "$user" "$PID" "$VmSize" "$VmRss" "$rchar1" "$wchar1" "$rateR" "$rateW" "$startDate")

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

    #Nº processos que queremos ver
    if [[ -v argOpt[p] ]]; then
        p=${argOpt['p']}
    #Se não dermos nenhum valor ao -p, fica com o valor do tamanho do array
    #Ou seja printa todos
    else
        p=${#arrayAss[@]}
    fi

    if [[ -v argOpt[m] ]]; then
        #Ordenação da tabela pelo MEM
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k4 | head -n $p

    elif [[ -v argOpt[t] ]]; then
        #Ordenação da tabela pelo RSS
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k5 | head -n $p

    elif [[ -v argOpt[d] ]]; then
        #Ordenação da tabela pelo RATER
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k8 | head -n $p

    elif [[ -v argOpt[w] ]]; then
        #Ordenação da tabela pelo RATEW
        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k9 | head -n $p

    else
        #Ordenação default da tabela, ordem alfabética dos processos
        ordem="-n" #Como é por ordem alfabética temos de mudar a ordem para '-n'

        printf '%s \n' "${arrayAss[@]}" | sort $ordem -k1 | head -n $p

    fi

}

listarProcessos ${@: -1} #este agumento passado, é para os segundos, visto que é passado em todas as opções, e é sempre o último