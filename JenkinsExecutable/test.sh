#! /usr/bin/env bash
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*environmentproperties*.csv")
do
	file = $i;
	IFS=','
	read -a headers
	while read -a line; do
	    for i in "${!line[@]}"; do
	        echo "${headers[i]}: ${line[i]}"
	    done
	done < "$file"
done
unset IFS