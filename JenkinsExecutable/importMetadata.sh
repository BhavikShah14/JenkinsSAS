#! /usr/bin/env bash
echo "##############################################################################################################################################################"
echo "Start of SPK explode"

#Explode the spk into a folder with same name as the spk but with extension .spkd

for i in $(find $(dirname $(readlink -f $0))/.. -name "*.spk")
do
	unzip -o "$i" -d "$i""d"
	#Copy the sub properties files outside
	for j in $(find "$i""d" -name "*.subprop")
	do
		cp $j $i.subprop
		chmod 775 $i.subprop
	done
done

echo "End of SPK explode"
echo "##############################################################################################################################################################"

echo "##############################################################################################################################################################"
echo "Start of lookup creation calling createHash.awk"

#Create a HASH for replacing the subprop files
#Uses the environment properties file to find the replacement
#determines the source of spk and the target of spk from the parameters source and target
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*environmentproperties*.csv")
do
	key=($(awk -v source=${source} -f JenkinsExecutable/createHash1.awk $i))
	value=($(awk -v target=${target} -f JenkinsExecutable/createHash1.awk $i ))
	RC=$?
	
	#Check Return Code
	if [ $RC -ne 0] ; then
	echo
	exit $RC
	fi
done



echo "End of lookup array creation from environmentproperties"
echo "##############################################################################################################################################################"

echo "##############################################################################################################################################################"
echo "Start of updating subprop files with target values"

#using sed to replace the files
for file in $(find $(dirname $(readlink -f $0))/.. -iname "*.spk.subprop")
do
	for count in ${!key[@]}
	do
		sed -i -- s:"${key[count]}":"${value[count]}":g "$file"
	done
done

echo "End of subprop file update"
echo "##############################################################################################################################################################"

#Deploy all spk's in the following order
#1 Roles
#2 User Groups
#3 Users
#4 ACT's
#5 Servers
#6 Libraries if separate spk created
#7 All other spks


for i in $(find $(dirname $(readlink -f $0))/.. -iname  "*.spk" ! -iname "*roles*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11 -subprop $i.subprop 
done

#Roles spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*roles*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11 -subprop $i.subprop
done

#User Groups spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*usergroups*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11 -subprop $i.subprop
done

#Users spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*users*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11 -subprop $i.subprop
done

#ACT spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*ACT*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11 -subprop $i.subprop
done

#Servers spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*servers*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11 -subprop $i.subprop
done

#Libraries spk
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*libraries*.spk")
do
	${ImportPackagePath}/ImportPackage -profile "SASAdmin" -package "$i" -target / -preservePaths -includeACL -disableX11 -subprop $i.subprop
done


