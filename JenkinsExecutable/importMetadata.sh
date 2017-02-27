#! /usr/bin/env bash

for i in $(find $(dirname $(readlink -f $0))/.. -name "*.spk")
do
	unzip -o "$i" -d "$i""d"
	for j in $(find "$i""d" -name "*.spk")
	do
		unzip -o "$j" -d "$j""d"
	done
done

${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "Metadata/Jenkins.spk" -target / -includeACL -disableX11
