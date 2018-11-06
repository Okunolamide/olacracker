#! /bin/bash

infile=$1
outfile=$2
tmpfile="tmp.txt"
tmpfile2="tmp2.txt"
logfile="log.txt"
mismatched_hashes=./mismatched_des.hashes

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

# Formatting finished at this point
awk -F ":" '{print $1, $2}' $infile > $tmpfile
printf "%d solved hashes before sorting\n" $(wc -l < $tmpfile)
sort -u -o $tmpfile $tmpfile
printf "%d solved hashes after sorting\n" $(wc -l < $tmpfile)

# echo "" > $logfile

# printf "Mismatched Hashes:" >> $logfile
# cat $mismatched_hashes >> $logfile
# printf "\n" >> $logfile

# Fix mismatched DES passwords
next_line=""
while read line; do
  # echo "Checking line: " $line >> $logfile
  next_line=$line
  while read mismatched; do
    # echo "Checking against: " $mismatched >> $logfile
    if [ "$line" == "$mismatched" ]; then
      next_line=${line:: -1}
      break
    fi
  done < $mismatched_hashes
  echo $next_line  >> $tmpfile2
  # printf "\n" >> $logfile
done < $tmpfile

cat $tmpfile2 > $outfile

rm $tmpfile
rm $tmpfile2