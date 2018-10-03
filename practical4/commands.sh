#!/bin/bash

potfile_path="practical4.potfile"
potfile_flag="--potfile-path="


if [ "$1" == "DES" ] 
then
	command="hashcat -m 1500 -a 0 DES.hashes ../dictionaries/rockyou.txt"
elif [ "$1" == "MD5Crypt" ]
then
	command="hashcat -a 0 -m 500 -O md5crypt.hashes ../dictionaries/rockyou.txt"
elif [ "$1" == "SHA256" ]
then
	command="hashcat -a 0 -m 7400 -O sha256.hashes ../dictionaries/rockyou.txt"
else
	command="Unknown command: " $1
fi

echo $command $potfile_flag $potfile_path