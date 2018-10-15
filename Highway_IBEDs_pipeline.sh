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
#process_radtags wordt aangeroepen
    DATE=$(date +"%d%m%Y")                                                                
    N=1                                                                                   
                                                                                          
    # Increment $N as long as a directory with that name exists                           
    while [[ -d "Clean_$DATE-$N" ]] ; do                                                  
        N=$(($N+1))                                                                       
    done   
if [ "$#" -eq 4 ]; then
    bash prep_IBEDs_pipeline.sh "${1}" "${2}" "${3}" "${4}" 
    pwd
    echo "Clean_" + "$DATE-$N"
    python ustacks.py "${3}" "${4}" "Clean_$DATE-$N"  
fi
if [ "$#" -eq 3 ]; then
    bash prep_IBEDs_pipeline.sh "${1}" "${2}" "${3}" 
    python ustacks.py "${2}" "${3}" "Clean_$DATE-$N" 
fi


