#! /usr/bin/env bash
IFS=','
read -a headers
while read -a line; do
    for i in "${!line[@]}"; do
        echo "${headers[i]}: ${line[i]}"
    done
done < "$file"
unset IFS