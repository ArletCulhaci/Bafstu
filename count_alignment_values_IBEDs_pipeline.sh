#!/bin/bash
cd ${1}
pwd
while IFS=, read -r  col1
do
    list=$(echo "$col1")
    names=$(echo $list | awk '{print $2}')
    rate1=$(cat ${names}_alignment.log | egrep 'rate' | awk '{print $1}')
    rate2=${rate1: : -1}
    echo "${names};${rate2}" >> ../alignment.txt
    #tr "\n" ";" <  total > counts.txt
    #sed 's/614_/\n614_/g'< counts.txt > counts2.txt
    #sed 's/210_/\n210_/g'< counts2.txt > Final_ustack_Values.txt
done < ${2}
sed -i '1 i\Sample;rate' ../alignment.txt
#sed -i '2d' Final_ustack_Values.txt
#rm counts.txt
#rm counts2.txt
#rm total

