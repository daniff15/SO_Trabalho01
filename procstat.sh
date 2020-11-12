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




if [ $1 == "a" ]; then
    cat /proc/$$/status | grep VmSize
    cat /proc/$$/status | grep VmRSS
    cat /proc/$$/io | grep rchar
    cat /proc/$$/io | grep wchar
    cat /proc/$$/comm
    # Para o alias correr, tem de se correr assim: 'source procstat.sh a'
    alias pss='ps -A --format comm,pid,ppid,pgid,sid'
    pss
else
    echo "Deu merda zé"
fi

# alias pss= "ps -A --format comm,pid,ppid,pgid,sid"





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