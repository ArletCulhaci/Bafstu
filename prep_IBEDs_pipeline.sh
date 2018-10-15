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

if [ "$#" -eq 4 ]; then 
    DATE=$(date +"%d%m%Y")
    N=1

    # Increment $N as long as a directory with that name exists
    while [[ -d "Clean_$DATE-$N" ]] ; do
        N=$(($N+1))
    done

    mkdir "${4}/Clean_$DATE-$N"	
    process_radtags -1 "${4}"/"${1}" -2 "${4}"/"${2}" -o ./"Clean_$DATE-$N" -b "${4}"/"${3}" -e sbfI -r -t 140 -q -D  -s 20 -w 0.13 
    echo  process_radtags -1 "${4}"/"${1}" -2 "${4}"/"${2}" -o ./"Clean_$DATE-$N" -b "${4}"/"${3}" -e sbfI -r -t 140 -q -D  -s 20 -w 0.13 > ./"Clean_$DATE-$N"/Command_log.txt
fi
if [ "$#" -eq 3 ]; then
    DATE=$(date +"%d%m%Y")
    N=1

    # Increment $N as long as a directory with that name exists
    while [[ -d "Clean_$DATE-$N" ]] ; do
        N=$(($N+1))
    done

    mkdir "${3}/Clean_$DATE-$N"	
    process_radtags -f "${3}"/"${1}" -o ./"Clean_$DATE-$N" -b "${3}"/"${2}" -e sbfI -r -t 140 -q -D  -s 20 -w 0.13 
    echo  process_radtags -f "${3}"/"${1}" -o ./"Clean_$DATE-$N" -b "${3}"/"${2}" -e sbfI -r -t 140 -q -D  -s 20 -w 0.13  > ./"Clean_$DATE-$N"/Command_log.txt
fi



