#!/bin/bash
# show usage information
if [ "${1}" == "--h" ] || [ "${1}" == "--help" ] || [ "${1}" == "-h" ] || [ "${1}" == "-help" ]
	then
		echo " " 
		echo "This pipeline analyzes RAD_seq data. It expects input files containing raw reads."
		echo "The pipeline returns files with RAD-tags for each sample." 
		echo "Highway_IBEDs_STACK_pipeline.sh runs diferen et components of the pipeline."
		echo "These componenets are: process_radtags, build loci etcccccc." 
		echo "" 
		echo "Way of usage (stand-alone) for paired-end reads:" 
		echo "bash Highway_IBEDs_STACK_pipeline.sh <inputfile1> <inputfile2>" 
		echo ""
		echo "Way of usage (stand-alone) for single end reads:"
		echo "bash Highway_IBEDs_STACK_pipeline.sh  <inputfile>"
		echo ""
		echo "The run time can be recorded with the following command:" 
		echo "time bash Highway_IBEDs_STACK_pipeline.sh <inputfile1> <inputfile2>"
		echo "time bash Highway_IBEDs_STACK_pipeline.sh <inputfile>"   
		echo ""  
	exit
fi
spinner ()
{
    PID=$!
    i=1
    sp="/-\|"
    echo -n ' '
    while [ -d /proc/$PID ]
        do
            #LS
            # printf "-"
            printf "\b${sp:i++%${#sp}:1}"
#\b${sp:i++%${#sp}:1}"
        done
} 
    # Increment $N as long as a directory with that name exists
# IF 13 = true, paired data 
if [ "$#" -eq 18 ]; then
    DATE=$(date +"%d%m%Y")
    N=1
    while [[ -d "${5}/STACKS_$DATE-$N" ]] ; do
        N=$(($N+1))
    done
    bash prep_IBEDs_pipeline.sh "${1}" "${2}" "${3}" "${5}" ${6} ${7} ${8} ${9} ${10} ${11} ${12} &>/dev/null &
    spinner
    mkdir ${5}/STACKS_$DATE-$N/stacks
    mkdir ${5}/STACKS_$DATE-$N/alignment
    echo "process_radtags is done"
    Rscript initial_reads_IBEDs_pipeline.R "Values_run_total_reads_bf_process.txt" ${5}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    echo "A plot containing the initial number of reads before process_radtags can be found in the following directory ${5}/"STACKS_$DATE-$N""
    file=$(ls ${17} | egrep -m 1 ".bt2")
    ref_index=${file::${#file}-6}
    while read col1
        do
          names=$(echo $col1 | awk '{print $2}') 
          bowtie2  -p 20 -x ${17}/$ref_index -1 ${5}/"STACKS_$DATE-$N/samples"/${names}.1.fq.gz -2 ${5}/"STACKS_$DATE-$N/samples"/${names}.2.fq.gz -S ${5}/"STACKS_$DATE-$N/alignment"/${names}.sam 2> ${5}/"STACKS_$DATE-$N/alignment"/${names}_alignment.log
          samtools view -Sb ${5}/"STACKS_$DATE-$N/alignment"/${names}.sam > ${5}/"STACKS_$DATE-$N/alignment"/${names}.bam
          samtools sort ${5}/"STACKS_$DATE-$N/alignment"/${names}.bam ${5}/"STACKS_$DATE-$N/alignment"/${names} 
          samtools index ${5}/"STACKS_$DATE-$N/alignment"/${names}.bam 
        done < ${3}
    bash count_alignment_values_IBEDs_pipeline.sh ${5}/STACKS_$DATE-$N/alignment ${3}
    Rscript alignment_visualisation.R "alignment.txt" ${5}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    echo "A plot containing the alignment rate per individual can be found in the following directory ${5}/"STACKS_$DATE-$N""
    ref_map.pl -T 15 -o ${5}/"STACKS_$DATE-$N/stacks" --popmap ${4} --samples ${5}/"STACKS_$DATE-$N/alignment"  -X "populations: -r 0.30 --vcf --max_obs_het 0.8 --min_maf 0.1" -X "gstacks: --rm-pcr-duplicates" 2> ${5}/"STACKS_$DATE-$N/stacks"/log_ref_map.txt  &>/dev/null & 
    spinner
    echo "Ref_map is done"
    echo "ref_map.pl -T 15 -o ${5}/"STACKS_$DATE-$N/stacks" --popmap ${4} --samples ${5}/"STACKS_$DATE-$N/alignment"  -X "populations: -r 0.30 --vcf" -X "gstacks: --rm-pcr-duplicates"" >> ${5}/"STACKS_$DATE-$N"/Command_log.txt
    Rscript convert_vcf_matrix.R  "populations.haps.vcf" ${5}/"STACKS_$DATE-$N/stacks" --quiet 2>&1 >/dev/null
    python3.5 matrix_filter.py ${5}/"STACKS_$DATE-$N/stacks" "SNP_matrix.csv" &>/dev/null

fi
#ref_map.pl -T 15 -o ./ --popmap ../Popmap_17_dec_selection.txt --samples ../bowtie_forward  -X "populations:--vcf" 2> log_ref_map_11_12.txt
if [ "$#" -eq 17 ]  &&  [ "${17}" -eq 2 ] ; then
       DATE=$(date +"%d%m%Y")
    N=1
    while [[ -d "${4}/STACKS_$DATE-$N" ]] ; do
        N=$(($N+1))
    done
    #mkdir ${4}/"STACKS_$DATE-$N
    bash prep_IBEDs_pipeline.sh "${1}" "${2}" "${4}" "${5}" ${6} ${7} ${8} ${9} ${10} ${11} &>/dev/null &
    spinner
    mkdir ${4}/STACKS_$DATE-$N/stacks
    mkdir ${4}/STACKS_$DATE-$N/alignment
    echo "process radtags is done"
    Rscript initial_reads_IBEDs_pipeline.R "Values_run_total_reads_bf_process.txt" ${4}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    echo "A plot containing the initial number of reads before process_radtags can be found in the following directoty ${4}/"STACKS_$DATE-$N""
    file=$(ls ${16} | egrep -m 1 ".bt2")
    ref_index=${file::${#file}-6}
    while read col1
        do
          names=$(echo $col1 | awk '{print $2}')
          bowtie2 -p 20 -x ${16}/$ref_index -U ${4}/"STACKS_$DATE-$N/samples"/${names}.fq.gz -S ${4}/"STACKS_$DATE-$N/alignment"/${names}.sam 2> ${4}/"STACKS_$DATE-$N/alignment"/${names}_alignment.log
          samtools view -Sb ${4}/"STACKS_$DATE-$N/alignment"/${names}.sam > ${4}/"STACKS_$DATE-$N/alignment"/${names}.bam
          samtools sort ${4}/"STACKS_$DATE-$N/alignment"/${names}.bam ${4}/"STACKS_$DATE-$N/alignment"/${names}
          samtools index ${4}/"STACKS_$DATE-$N/alignment"/${names}.bam
        done < ${2}
    bash count_alignment_values_IBEDs_pipeline.sh ${4}/STACKS_$DATE-$N/alignment ${2}
    Rscript alignment_visualisation.R "alignment.txt" ${4}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    ref_map.pl -T 15 -o ${4}/"STACKS_$DATE-$N/stacks" --popmap ${3} --samples ${4}/"STACKS_$DATE-$N/alignment"  -X "populations: -r 0.30--vcf" -X "gstacks: --rm-pcr-duplicates"  2> ${4}/"STACKS_$DATE-$N/stacks"/log_ref_map.txt
   echo "ref_map.pl -T 15 -o ${4}/"STACKS_$DATE-$N/stacks" --popmap ${3} --samples ${4}/"STACKS_$DATE-$N/alignment"  -X "populations: -r 0.30--vcf --max_obs_het 0.8 --min_maf 0.1" -X " gstacks: --rm-pcr-duplicates"">> ${4}/"STACKS_$DATE-$N"/Command_log.txt
   Rscript convert_vcf_matrix.R  "populations.haps.vcf" ${4}/"STACKS_$DATE-$N/stacks" --quiet 2>&1 >/dev/null
   python3.5 matrix_filter.py ${4}/"STACKS_$DATE-$N/stacks" "SNP_matrix.csv" 

fi 

if [ "$#" -eq 17 ] && [ "${17}" -eq 4 ]; then
      DATE=$(date +"%d%m%Y")
    N=1
    while [[ -d "${5}/STACKS_$DATE-$N" ]] ; do
        N=$(($N+1))
    #echo $N
    done
    bash prep_IBEDs_pipeline.sh "${1}" "${2}" "${3}" "${5}" ${6} ${7} ${8} ${9} ${10} ${11} ${12}  &>/dev/null &
    spinner
    Rscript initial_reads_IBEDs_pipeline.R "Values_run_total_reads_bf_process.txt" ${5}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    echo "A plot containing the initial number of reads before process_radtags can be found in the following directory ${5}/"STACKS_$DATE-$N/samples""
    python ustacks_IBEDs_pipeline.py ${3} ${5} "STACKS_$DATE-$N" ${14} ${10} ${11} &>/dev/null 
    spinner
    echo "ustacks is done"
    #python ustacks.py "${3}" "${4}" "STACKS_$DATE-$N" "paired" 
    bash count_ustacks_values_IBEDs_pipeline.sh "${5}/STACKS_$DATE-$N/stacks" ${3}
    Rscript ustacks_values_IBEDs_pipeline.R "Final_ustack_Values.txt" ${5}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    cstacks -o ${5}/"STACKS_$DATE-$N"/stacks -s ${5}/"STACKS_$DATE-$N"/stacks/${15} -s ${5}/"STACKS_$DATE-$N"/stacks/${16}  -n ${10} -p 15 2>  ${5}/"STACKS_$DATE-$N"/cstacks.log &
    spinner
    echo "cstacks -o ${5}/"STACKS_$DATE-$N"/stacks -s ${5}/"STACKS_$DATE-$N"/stacks/${15} -s ${5}/"STACKS_$DATE-$N"/stacks/${16}  -n ${10} -p 15 2>  ${5}/"STACKS_$DATE-$N"/cstacks.log &" >> ${5}/"STACKS_$DATE-$N"/Command_log.txt
    echo "cstacks is done"
    python sstacks_IBEDs_pipeline.py ${3} ${5} "STACKS_$DATE-$N/stacks" ${14} &
    spinner
    echo "sstacks is done" 
    bash count_sstacks_values_IBEDs_pipeline.sh "${5}/STACKS_$DATE-$N/stacks" ${3}
    Rscript sstacks_values_IBEDs_pipeline.R "Final_sstack_Values.txt" ${5}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    #python tsv2bam_IBEDs_pipeline.py ${3} ${5} "STACKS_$DATE-$N" ${14} ${4} 
    rename 's/\.1\././' ${5}/STACKS_$DATE-$N/stacks/*.tsv.gz 
    tsv2bam -P  ${5}/STACKS_$DATE-$N/stacks  -M  ${4}  -R ${5}/STACKS_$DATE-$N/samples  &> ${5}/STACKS_$DATE-$N/tsv2bam.log  &
    echo "tsv2bam -P  ${5}/STACKS_$DATE-$N/stacks  -M  ${4}  -R ${5}/STACKS_$DATE-$N/samples  &> ${5}/STACKS_$DATE-$N/tsv2bam.log  &" >> ${5}/"STACKS_$DATE-$N"/Command_log.txt
    spinner
    echo "tsv2bam is done"
    gstacks -P  "${5}/STACKS_$DATE-$N/stacks" -M ${4} -t 5 &>/dev/null &
    spinnir
    echo "gstacks -P  "${5}/STACKS_$DATE-$N/stacks" -M ${4} -t 5 &>/dev/null &" >> ${5}/"STACKS_$DATE-$N"/Command_log.txt
    echo "gstacks is done"
    populations -P "${5}/STACKS_$DATE-$N/stacks" --popmap ${4} --genepop --vcf -t 5 &>/dev/null &
    spinner
    echo "populations -P "${5}/STACKS_$DATE-$N/stacks" --popmap ${4} --genepop --vcf -t 5 &>/dev/null &" >> ${5}/"STACKS_$DATE-$N"/Command_log.txt
    echo "Populations is done"
    Rscript convert_vcf_matrix.R  "populations.haps.vcf" ${5}/"STACKS_$DATE-$N/stacks" --quiet 2>&1 >/dev/null
    python3.5 matrix_filter.py ${5}/"STACKS_$DATE-$N/stacks" "SNP_matrix.csv" &>/dev/null

fi
#If 12=false, single end data
if [ "$#" -eq 16 ]; then
        DATE=$(date +"%d%m%Y")
    N=1
    while [[ -d "${4}/STACKS_$DATE-$N" ]] ; do
        N=$(($N+1))
    echo $N
    done
    #mkdir ${3}/"STACKS_$DATE-$N"
    bash prep_IBEDs_pipeline.sh ${1} ${2} ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11} &>/dev/null &
    spinner
    echo "process radtags is done"
    Rscript initial_reads_IBEDs_pipeline.R "Values_run_total_reads_bf_process.txt" ${4}/"STACKS_$DATE-$N"
    echo "A plot containing the initial number of reads before process_radtags can be found in the following directoty ${4}/"STACKS_$DATE-$N""  
    python ustacks_IBEDs_pipeline.py ${2} ${4} "STACKS_$DATE-$N" ${13} ${9} ${10} &>/dev/null &
    spinner
    echo "ustacks is done"
    bash count_ustacks_values_IBEDs_pipeline.sh "${4}/STACKS_$DATE-$N/stacks" ${2}  
    Rscript ustacks_values_IBEDs_pipeline.R "Final_ustack_Values.txt" ${4}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    cstacks -o ${4}/"STACKS_$DATE-$N/stacks" -s ${4}/"STACKS_$DATE-$N"/stacks/${14} -s ${4}/"STACKS_$DATE-$N"/stacks/${15}  -n ${9} -p 15 2>  ${4}/"STACKS_$DATE-$N"/cstacks.log &
    spinner
    echo " cstacks -o ${4}/"STACKS_$DATE-$N/stacks" -s ${4}/"STACKS_$DATE-$N"/stacks/${14} -s ${4}/"STACKS_$DATE-$N"/stacks/${15}  -n ${9} -p 15 2>  ${4}/"STACKS_$DATE-$N"/cstacks.log" >> ${4}/"STACKS_$DATE-$N"/Command_log.txt
    echo "cstacks is done"
    python sstacks_IBEDs_pipeline.py ${2} ${4} "STACKS_$DATE-$N/stacks" ${13} &>/dev/null &
    spinner
    echo "sstacks is done"
    bash count_sstacks_values_IBEDs_pipeline.sh "${4}/STACKS_$DATE-$N/stacks" ${2} 
    Rscript sstacks_values_IBEDs_pipeline.R "Final_sstack_Values.txt" ${4}/"STACKS_$DATE-$N" --quiet 2>&1 >/dev/null
    tsv2bam -P  ${4}/STACKS_$DATE-$N/stacks  -M  ${3}  &> ${4}/STACKS_$DATE-$N/tsv2bam.log  &
    spinner
    echo "tsv2bam -P  ${4}/STACKS_$DATE-$N/stacks  -M  ${3}  &> ${4}/STACKS_$DATE-$N/tsv2bam.log" >> ${4}/"STACKS_$DATE-$N"/Command_log.txt
    echo "tsv2bam is done"
    gstacks -P  "${4}/STACKS_$DATE-$N/stacks" -M ${3} -t 5 &>/dev/null &
    spinner
    echo "gstacks -P  "${4}/STACKS_$DATE-$N/stacks" -M ${3} -t 5" >> ${4}/"STACKS_$DATE-$N"/Command_log.txt
    echo "gstacks is done"
    populations -P "${4}/STACKS_$DATE-$N/stacks" --popmap ${3} --genepop --vcf -t 5 &>/dev/null &
    spinner
    echo "populations -P "${4}/STACKS_$DATE-$N/stacks" --popmap ${3} --genepop --vcf -t 5" >> ${4}/"STACKS_$DATE-$N"/Command_log.txt
    echo "Populations is done"
    Rscript convert_vcf_matrix.R  "populations.haps.vcf" ${4}/"STACKS_$DATE-$N/stacks" --quiet 2>&1 >/dev/null
    python3.5 matrix_filter.py ${4}/"STACKS_$DATE-$N/stacks" "SNP_matrix.csv" &>/dev/null
 
fi

sleep 5
