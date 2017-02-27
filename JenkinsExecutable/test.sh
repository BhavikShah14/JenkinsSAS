#!/bin/bash
file = "/Metadata/environmentProperties.csv"
IFS=','
read -a headers
while read -a line; do
    for i in "${!line[@]}"; do
        echo "${headers[i]}: ${line[i]}"
    done
done