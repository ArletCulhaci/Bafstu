#!/bin/bash
touch total
touch counts.txt
while IFS=, read -r  col1
do
    list=$(echo "$col1")
    names=$(echo $list | awk '{print $2}')
    cat  ustacks_${names}_H_n1_.log | egrep -o "614.*gz|210.*gz">> total
    cat  ustacks_${names}_H_n1_.log | egrep "Loaded" | awk '{print $2}' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "primary" | awk '{print $1}' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "primary" | awk '{print $4}' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "primary" | awk '{print $7}' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "secondary" | sed -n "2p" | awk '{print $8}' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "Blacklisted" | awk '{print $2}' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "blacklisted" | awk '{print $7}'>> total
    cat  ustacks_${names}_H_n1_.log | egrep "Assembled|Final" | egrep -v "blacklisted" | sed -n '1p' | awk '{print $5}' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "Assembled|Final" | egrep -v "blacklisted" | sed -n '2p' | awk '{print $3}' | cut -d'=' -f 2 | sed 's/.$//' >> total 
    cat  ustacks_${names}_H_n1_.log | egrep "Assembled|Final" | egrep -v "blacklisted" | sed -n '2p' | awk '{print $4}' | cut -d'=' -f 2 | sed 's/.$//' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "Assembled|Final" | egrep -v "blacklisted" | sed -n '2p' | awk '{print $5}' | cut -d'=' -f 2 | sed 's/.$//' >> total
    cat  ustacks_${names}_H_n1_.log | egrep "Assembled|Final" | egrep -v "blacklisted" | sed -n '2p' | awk '{print $6}' | cut -d'=' -f 2  >> total
    tr "\n" "\t" <  total > counts.txt
    sed 's/614_/\n614_/g'< counts.txt > counts2.txt
    sed 's/210_/\n210_/g'< counts2.txt > Final_ustack_Values.txt
done < /media/biolinux/Data/Astrid_RADseq_data/barcodes.csv
sed -i '1 i\Sample\tTotal Reads\tInitial nr stacks\tNr primary reads\tPercentage primary reads\tPerecentage secondary reads\tInital nr blacklisted stacks\t Final nr blacklisted stacks\tFinal nr loci\tMean coverage\tstdev\tMax\tNr reads in stacks' Final_ustack_Values.txt
sed -i '2d' Final_ustack_Values.txt
rm counts.txt
rm counts2.txt
rm total
