#!/bin/sh
# $1 = dictionary name, $2 = number of chars, $3 = output file name
FILE_NAME=$1
NUM_CHARS=$2
OUT_FILE=$3

#echo $1 $2 $3

if [ length($FILE_NAME) -lt $NUM_CHARS ]
then
echo "YEs"
fi

# awk '{if [length($1) = $NUM_CHARS] then print $1}' $FILE_NAME  


