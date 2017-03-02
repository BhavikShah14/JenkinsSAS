#! /usr/bin/env bash

#Error check function
#Parameter 1 is the error code
#Parameter 2 is the error text
function error_check 
{
	#Check Return Code
	if [ $1 -ne 0 ]
	then
		echo "*** $2 Error Code : $1 ***"
		exit $1
	fi
}
echo "##############################################################################################################################################################"
echo "Start of SPK explode"
echo "##############################################################################################################################################################"
echo
echo
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
	RC=$?
			
	error_check $RC "Exiting from explode spk for $i"
done
echo
echo
echo "##############################################################################################################################################################"
echo "End of SPK explode"
echo "##############################################################################################################################################################"
echo
echo
echo "##############################################################################################################################################################"
echo "Start of lookup creation calling createHash.awk"
echo "##############################################################################################################################################################"
echo
echo

#Create a HASH for replacing the subprop files
#Uses the environment properties file to find the replacement
#determines the source of spk and the target of spk from the parameters source and target
for i in $(find $(dirname $(readlink -f $0))/.. -iname "*environmentproperties*.csv")
do
	key=($(awk -v source=${source} -f JenkinsExecutable/createHash.awk $i))
	value=($(awk -v target=${target} -f JenkinsExecutable/createHash.awk $i ))
	RC=$?

	error_check $RC "Exiting from Hash Lookup creation from environment Properties"
done

echo
echo
echo "##############################################################################################################################################################"
echo "End of lookup array creation from environmentproperties"
echo "##############################################################################################################################################################"
echo
echo
echo "##############################################################################################################################################################"
echo "Start of updating subprop files with target values"
echo "##############################################################################################################################################################"
echo
echo
#using sed to replace the files
for file in $(find $(dirname $(readlink -f $0))/.. -iname "*.spk.subprop")
do
	for count in ${!key[@]}
	do
		sed -i -- s:"${key[count]}":"${value[count]}":g "$file"
		RC=$?
		
		error_check $RC "Exiting from Subprop update for $i"
	done
done
echo
echo
echo "##############################################################################################################################################################"
echo "End of subprop file update"
echo "##############################################################################################################################################################"

echo
echo

