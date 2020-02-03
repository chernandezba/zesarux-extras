#!/bin/bash



for i in *; do 
	#echo "$i" 
	VERSION=`hexdump -C $i |head -1|awk '{printf "%s\n",$10}' ` 
	#echo $VERSION 
	if [ "$VERSION" == "00" ]; then 
	  echo "$i --Version $VERSION --" 
	fi
done
