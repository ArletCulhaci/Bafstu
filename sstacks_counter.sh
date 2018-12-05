#!/bin/bash 
cd ${1}
touch total
touch counts.txt
while IFS=, read -r  col1
do
    list=$(echo "$col1")
    names=$(echo $list | awk '{print $2}')
    echo ${names} >> total
    sed -n '13p' < sstack_${names}.log | awk '{print $9}'>>total 
    sed -n '13p' < sstack_${names}.log | awk '{print $1}'>>total 
    sed -n '14p' < sstack_${names}.log | awk '{print $1}'>>total
sed -n '14p' < sstack_${names}.log | awk '{print $4}' >>total
sed -n '15p' < sstack_${names}.log | awk '{print $1}'>>total
sed -n '16p' < sstack_${names}.log | awk '{print $1}' >>total
 sed -n '17p' < sstack_${names}.log | awk '{print $1}' >>total
sed -n '17p' < sstack_${names}.log | awk '{print $8}' >>total
sed -n '19p' < sstack_${names}.log | awk '{print $6}'>> total
sed -n '20p' < sstack_${names}.log | awk '{print $1}' >>total
sed -n '20p' < sstack_${names}.log | awk '{print $7}'>>total 
sed -n '20p' < sstack_${names}.log | awk '{print $11}'>>total 
sed -n '21p' < sstack_${names}.log | awk '{print $1}' >>total
sed -n '22p' < sstack_${names}.log | awk '{print $1}' >>total
sed -n '23p' < sstack_${names}.log | awk '{print $1}'>>total
sed -n '24p' < sstack_${names}.log | awk '{print $1}' >>total
sed -n '25p' < sstack_${names}.log | awk '{print $1}'>>total
    tr "\n" ";" <  total > counts.txt
    sed 's/614_/\n614_/g'< counts.txt > counts2.txt
    sed 's/210_/\n210_/g'< counts2.txt > Final_sstack_Values.txt
done < ${2}
sed -i '1 i\Sample;Catalog loci;Sample loci;Matching loci;no varified haplotypes;ambigous loci;Loci with unaccounted SNPs;Total haplotypes;Verified haplotypes;gapped alignments;Matched loci;Total haplotypes;Verified haplotypes;Unmatched loci;Ambigous loci;Loci with unaccounted SNPs;No verified haplotypes;Inconsistent alignments' Final_sstack_Values.txt
sed -i '2d' Final_sstack_Values.txt
#rm counts.txt
#rm counts2.txt
#rm total
