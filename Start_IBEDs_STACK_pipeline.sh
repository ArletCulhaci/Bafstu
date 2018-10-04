#!/bin/bash
cd /home/biolinux/Documents/Arlet_files/scripts
sleep 5
# show usage information
if [ "${1}" == "--h" ] || [ "${1}" == "--help" ] || [ "${1}" == "-h" ] || [ "${1}" == "-help" ]
	then
		echo " " 
		echo "This pipeline analyzes RAD_seq data. it expects input files containing raw reads."
		echo "The pipeline returns files with RAD-tags for each sample." 
		echo "Start_IBEDs_STACK_pipeline.sh starts the highway bash script(IBEDs_STACK_pipeline.sh)." 
		echo "the highway bash script runs other modules."
		echo "" 
		echo "Way of usage (stand-alone):" 
		echo "bash Start_IBEDs_STACK_pipeline.sh" 
		echo ""
		echo "The run time can be recorded with the following command:" 
		echo "time bash Start_IBEDs_STACK_pipeline.sh"   
		echo ""  
	exit
fi

#Show all files in current working directory
echo "Files in your current working directory" 
echo " " 
ls -h --color
echo " " 
sleep 2

#checking if all the needed files are present, if not the pipeline is aborted.
missing=false
for pipelineFile in \
	Highway_IBEDs_pipeline.sh\
        prep_IBEDs_pipeline.sh\
        ustaks.py\
	do
		if ! [ -f ${pipelineFile} ] then
				echo "somethingwrong"
                                sleep 10
				echo ${pipelineFile}" does not exist." 
				missing=true
                                sleep 2
		fi

                if ${missing} then
                    sleep 10
	            echo "The IBEDs STACK pipeline is aborted."
	            echo " "
	            #sleep 10
	            read -p "Press enter to exit: " enter
	            if [[ "${enter}" == " " ]] then
                         echo "we made it"	
                     fi 
	done

# asking user input
read -p "Please enter a prefix that will be used for all output files: " prefix
echo " " 
read -p "Please enter P (paired-end) or S (single): " porsingle
echo " " 
read -p "Enter your barcode file: " barcodeFile
echo " "
read -p "Enter the absolute path to the directory containing the input files: " a_path
echo " "

if [[ "${porsingle}" == "P" ]] || [[ "${porsingle}" == "p" ]]
	then
		read -p "Enter both input files: " inputFile1 inputFile2
		bash Highway_IBEDs_pipeline.sh ${inputFile1} ${inputFile2} ${barcodeFile} ${prefix} ${a_path}
fi
if [[ "${porsingle}" == "S" ]] || [[ "${porsingle}" == "s" ]]
	then 
		read -p "Enter your input file: " inputfile1
		bash Highway_IBEDs_pipeline.sh ${inputFile1} ${barcodeFile} ${prefix} ${a_path}
fi
sleep 50
