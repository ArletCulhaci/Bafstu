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
    while [[ -d "${3}/Clean_$DATE-$N" ]] ; do                                                  
        N=$(($N+1))                                                                       
    done

# IF 13 = true, paired data  
if [ "$#" -eq 13 ]; then  
    bash prep_IBEDs_pipeline.sh "${1}" "${2}" "${3}" "${4}" ${5} ${6} ${7} ${8} ${9} ${10} ${11}
    #python ustacks.py "${3}" "${4}" "Clean_$DATE-$N" "paired" 
fi
#If 12=false, single end data
if [ "$#" -eq 12 ]; then
    bash prep_IBEDs_pipeline.sh ${1} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10}
    #python ustacks.py "${2}" "${3}" "Clean_$DATE-$N" "single"
    #while true;do echo -n .;sleep 1;done &
#python ustacks.py ${2} ${3} "Clean_$DATE-$N" ${12} &>/dev/null &
# or do something else here
#kill $!; trap 'kill $!' SIGTERM
#echo done
    Rscript test_r.R "Values_run_total_reads_bf_process.txt" ${3}/"Clean_$DATE-$N" --save --quiet 2>&1 >/dev/null
    echo "A plot containing the initial number of reads before process_radtags can be found in the following directoty ${3}/"Clean_$DATE-$N"" 
    python ustacks.py ${2} ${3} "Clean_$DATE-$N" ${12} ${8} ${9} &
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
    echo "ustacks is done"
    bash counter.sh "${3}/Clean_$DATE-$N"
    Rscript ustacls_r.R "Final_ustack_Values.txt" ${3}/"Clean_$DATE-$N"
    cstacks -o ${3}/"Clean_$DATE-$N" -s ${3}/"Clean_$DATE-$N"/614_fem_6-11-15 -s ${3}/"Clean_$DATE-$N"/614_male_6-11-15  -n ${8} -p 5 2> cstacks.log
fi

sleep 12
