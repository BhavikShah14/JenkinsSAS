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