#!/bin/bash

# command=""

if [ "$1" == "DES" ] 
then
	command="hashcat -m 1500 -a 0 DES.hashes ../dictionaries/rockyou.txt"
elif [ "$1" == "MD5Crypt" ]
then
	command="hashcat -a 0 -m 500 -O md5crypt.hashes ../dictionaries/rockyou.txt2"
else
	command="nothing"
fi

echo $command