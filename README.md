# SO_Trabalho01
Trabalho Prático 01 - SO

## Estatísticas de Processamento em Bash
Este script permite a visualização da quantidade de memória total e da memória residente em memória física, do número total de bytes I/O,e da e taxa de leitura/escrita (bytes/sec) dos processos seleccionados nos últimos sec segundos.

###  Início
Bem-vIndo ao README.md, aqui é possível ver todas as instruções para executar e entender o projeto realizado.

### Pré-requesitos 
Para executar o *script procstat.sh* precisa de um terminal bash, pode ser numa máquina com uma distribuição Ubuntu, ou numa virtual box.
Antes de executar o *script*, terá de lhe atribuir permissões, para isso terá de executar o seguinte código na pasta onde se encontra o *procstat.sh* :

```
chmod u+x procstat.sh
```

### Opções para executar o script

Para executar o *script prochstat.sh* há estas opções disponíveis:

    -c          : Seleção de processos a utilizar atravez de uma expressão regular
    -u          : Seleção de processos a visualizar através do nome do utilizador
    -r          : Ordenação reversa
    -s          : Seleção de processos a visualizar num periodo temporal - data mínima
    -e          : Seleção de processos a visualizar num periodo temporal - data máxima
    -d          : Ordenação da tabela por RATER (decrescente)
    -m          : Ordenação da tabela por MEM (decrescente)
    -t          : Ordenação da tabela por RSS (decrescente)
    -w          : Ordenação da tabela pOR RATEW (decrescente)
    -p          : Número de processos a visualizar

Seguem-se alguns exemplos de execução:

```
sudo ./procstat.sh -m -r 10
sudo ./procstat.sh -s "Nov 29 13:10" -e "Nov 19 16:30" 10
sudo ./procstat.sh -t -c "sys.*" 10
```

### Relatório
Este projeto está acompanhado por um [Relatório](/Relatório), onde todas as implementações são explicadas de forma bastante específica e proiminente, e onde as principais conclusões e elações da realização do trabalho prático são expostas.

## Autores

 - **[Pedro Sobral](https://github.com/TheScorpoi) - 98491**
 - **[Daniel Figueiredo](https://github.com/daniff15) - 98491**
