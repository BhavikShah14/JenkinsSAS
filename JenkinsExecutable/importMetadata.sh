#Explode the spk into a folder with same name as the spk but with extension .spkd
#! /usr/bin/env bash

for i in $(find $(dirname $(readlink -f $0))/.. -name "*.spk")
do
	unzip -o "$i" -d "$i""d"
	#Copy the sub properties files outside
	for j in $(find "$i""d" -name "*.subprop")
	do
		cp $j $i.subprop
	done
done

#Deploy all spk's in the following order
#1 Roles
#2 User Groups
#3 Users
#4 Servers
#5 Libraries if separate spk created
#6 All other spks

#Roles spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*roles*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11
done

#User Groups spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*usergroups*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -includeACL -disableX11
done

#Users spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*users*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -includeACL -disableX11
done

#Servers spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*servers*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -includeACL -disableX11
done

#Libraries spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*libraries*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -includeACL -disableX11
done

for i in $(find $(dirname $(readlink -f $0))/.. -name  "*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -includeACL -disableX11
done

