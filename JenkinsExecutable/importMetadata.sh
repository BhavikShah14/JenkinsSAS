#Explode the spk into a folder with same name as the spk but with extension .spkd
#! /usr/bin/env bash

for i in $(find $(dirname $(readlink -f $0))/.. -name "*.spk")
do
	unzip -o "$i" -d "$i""d"
	for j in $(find "$i""d" -name "*.subprop")
	do
		cp $j $i.subprop
	done
done

${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "Metadata/Jenkins.spk" -target / -includeACL -disableX11
