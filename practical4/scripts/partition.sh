#! /bin/bash

infile="../hashes/lupos.hashes"
outdir="../hashes"

des="$outdir/DES.hashes"
md5crypt="$outdir/MD5Crypt.hashes"
sha256="$outdir/SHA256.hashes"
sha512="$outdir/SHA512.hashes"
pbkdf2="$outdir/pbkdf2.hashes"
argon="$outdir/argon.hashes"

total_hashes=$(wc -l < $infile)
echo "Total number of hashes in $infile: " $total_hashes

# Grab DES -m -1500
awk 'length($0) == 13 { print } ' $infile > $des
des_no_hashes=$(wc -l < $des)

# Grab MD5crypt -m 500
awk '/^\$1\$/ { print } ' $infile > $md5crypt
md5crypt_no_hashes=$(wc -l < $md5crypt)

# Grab SHA 256 crypt -m 7400 
awk '/^\$5\$/ { print } ' $infile > $sha256
sha256_no_hashes=$(wc -l < $sha256)

# Grab SHA 512 crypt -m 1800
awk '/^\$6\$/ { print } ' $infile > $sha512
sha512_no_hashes=$(wc -l < $sha512)

# Grab pbkdf2SHA
awk '/^\$pbkdf2-sha256\$/ { print } ' $infile > $pbkdf2
pbkdf2_no_hashes=$(wc -l < $pbkdf2)

# Grab Argon
awk '/^\$argon2i\$/ { print } ' $infile > $argon
argon_no_hashes=$(wc -l < $argon)

printf "DES: %s hashes \n" $des_no_hashes
printf "SHA256: %s hashes \n" $sha256_no_hashes
printf "SHA512: %s hashes \n" $sha512_no_hashes
printf "MD5: %s hashes \n" $md5crypt_no_hashes
printf "pbkdf2SHA: %s hashes \n" $pbkdf2_no_hashes
printf "argon: %s hashes \n" $argon_no_hashes

((total_parsed_hashes=$des_no_hashes + $sha256_no_hashes + $sha512_no_hashes + md5crypt_no_hashes + pbkdf2_no_hashes + argon_no_hashes))
printf "Total parsed hashes: %s\n" $total_parsed_hashes