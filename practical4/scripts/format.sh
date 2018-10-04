#! /bin/bash

infile=$1
outfile=$2

if [ "$1" == "" ]
then
  echo "No input file given.."
  exit
fi

if [ "$2" == "" ]
then
  echo "No output file given, using practical4.broken"
  outfile="practical4.broken"
fi

if [ "$1" == "$2" ]
then
  echo "I dont think you want to do that, files are the same!"
  exit
fi

awk -F ":" '{print $1, $2}' $infile > $outfile
