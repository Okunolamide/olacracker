#! /bin/bash
tmp="tmp.txt"
awk -F " " '{print $2}' $1 > $tmp

awk 'NR==FNR{a[$0];next} !($0 in a)' $tmp $2 > $3 
