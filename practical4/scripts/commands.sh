#!/bin/bash

potfile_path="practical4.potfile"
potfile_flag="--potfile-path="


if [ "$1" == "DES" ] then
	command="hashcat -m 1500 -a 0 hashes/DES.hashes ../dictionaries/rockyou.txt"

elif [ "$1" == "MD5Crypt" ] then
	command="hashcat -a 0 -m 500 -O hashes/MD5Crypt.hashes ../dictionaries/rockyou.txt"

elif [ "$1" == "SHA256" ] then
	command="hashcat -a 0 -m 7400 -O hashes/SHA256.hashes ../dictionaries/rockyou.txt"

elif [ "$1" == "SHA512" ] then
	command="hashcat -a 0 -m 1800 -O hashes/SHA512.hashes ../dictionaries/rockyou.txt"

# Could be DJANGO -m -10000 or CISCO-IOS -m 9200
# elif [ "$1" == "pbkdf2" ] then
# 	command="hashcat -a 0 -m 10000 -O hashes/pbkdf2.hashes ../dictionaries/rockyou.txt"

# elif [ "$1" == "argon" ] then
# 	command="hashcat -a 0 -m 7400 -O hashes/argon.hashes ../dictionaries/rockyou.txt"

else
	command="Unknown command: " $1
fi

echo $command $potfile_flag $potfile_path