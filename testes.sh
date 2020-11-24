#!/bin/bash

declare -A pessoas

# preenchendo o array
pessoas=(
		["joao"]=30
		["maria"]=30 
		["ana"]=25
	)

for i in "${!pessoas[@]}"
do
	echo "$i tem ${pessoas[$i]} anos"
done