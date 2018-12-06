#!/bin/bash
# show usage information
if [ "${1}" == "--h" ] || [ "${1}" == "--help" ] || [ "${1}" == "-h" ] || [ "${1}" == "-help" ]
	then
		echo " " 
		echo "This pipeline analyzes RAD_seq data. it expects input files containing raw reads."
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

# save number of individuals from the barcode file
num_ind="$(cat ${2} | wc -l)"

if [ "$#" -eq 11 ]; then 
    DATE=$(date +"%d%m%Y")
    N=1

    # Increment $N as long as a directory with that name exists
    while [[ -d "${4}/Clean_$DATE-$N" ]] ; do
        N=$(($N+1))
    done

    mkdir "${4}/Clean_$DATE-$N"	
    process_radtags -1 "${4}"/"${1}" -2 "${4}"/"${2}" -o ${4}/"Clean_$DATE-$N" -b "${3}" -e ${5} -r -t ${6} -q -D -s ${7} -w ${8}
    echo process_radtags -1 "${4}"/"${1}" -2 "${4}"/"${2}" -o ${4}/"Clean_$DATE-$N" -b "${3}" -e ${5} -r -t ${6} -q -D -s ${7} -w ${8} > ${4}/"Clean_$DATE-$N"/Command_log.txt
    num_ind="$((ls -l | egrep '.fq' | wc -l))"
    num_ind=num_ind-2
    echo ${num_ind}

fi
if [ "$#" -eq 10 ]; then
    DATE=$(date +"%d%m%Y")
    N=1

    # Increment $N as long as a directory with that name exists
    while [[ -d "${3}/Clean_$DATE-$N" ]] ; do
        N=$(($N+1))
    done

    mkdir "${3}/Clean_$DATE-$N"	
    process_radtags -f "${1}" -o ${3}/"Clean_$DATE-$N" -b "${2}" -e ${4} -r -t ${5} -q -D  -s ${6} -w ${7} &>/dev/null &
    PID=$!
    i=1
    sp="/-\|"
    echo -n ' '
    while [ -d /proc/$PID ]
        do
            printf "\b${sp:i++%${#sp}:1}"
#\b${sp:i++%${#sp}:1}"
        done
    echo "Process_RADtags is done"
    echo  process_radtags -f "${1}" -o ${3}/"Clean_$DATE-$N" -b "${2}" -e ${4} -r -t ${5} -q -D  -s ${6} -w ${7}  > ${3}/"Clean_$DATE-$N"/Command_log.txt
    cat ${3}/"Clean_$DATE-$N"/process_radtags* | tail -n +12 | awk '{print $2, $3, $6}' | head -${num_ind} | tr ' ' ';' > ${3}/"Clean_$DATE-$N"/Values_run_total_reads_bf_process.txt
    #Rscript test_r.R Values_run_total_reads_bf_process.txt ${3}/"Clean_$DATE-$N" --save --quiet 2>&1 >/dev/null
   # echo "A plot containing the initial number of reads before process_radtags can be found in the following directoty ${3}/"Clean_$DATE-$N"" 
fi

sleep 2
