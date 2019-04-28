#!/bin/bash
sleep 2
trap '
while true; do

    read -p "Do you really want to exit? All the created files will be deleted: " yn

    case $yn in

        [Yy]* )
                echo "Deleting files"
		sleep 5 
                exit 1;;

        [Nn]* )
                echo "Continue.."
		exit 255
		break;;

        * ) echo "Please answer yes or no.";;

    esac

done

' SIGINT

# show usage information
if [ "${1}" == "--h" ] || [ "${1}" == "--help" ] || [ "${1}" == "-h" ] || [ "${1}" == "-help" ]
	then
		echo " " 
		echo "This pipeline analyzes RAD_seq data. It expects input files containing raw reads."
		echo "The pipeline returns files with RAD-tags for each sample." 
		echo "Start_IBEDs_STACK_pipeline.sh starts the highway bash script(Highway_IBEDs_STACK_pipeline.sh)." 
		echo "The highway bash script runs other modules."
		echo "" 
		echo "Way of usage (stand-alone):" 
		echo "bash Start_IBEDs_STACK_pipeline.sh" 
		echo ""
		echo "The run time can be recorded with the following command:" 
		echo "time bash Start_IBEDs_STACK_pipeline.sh"   
		echo ""  
	exit
fi

# set default parameters
truncate_length=140
window_width=0.13
quality_threshold=20
dist_stacks=2
depth_stack=3
dist_sec_reads=1
ref_genome=false
paired=true
renzym=szzz

#Show all files in current working directory
echo "Files in your current working directory" 
echo " " 
tree -c 
echo " " 
sleep 2
a=$(python3 input_scherm.py)
analysis=$(echo $a | egrep -c "novo" )
data=$(echo $a | egrep -c 'single')
a_path=$(echo $a | tr " " "\n" | egrep '\-f' | awk '{print substr($0,3,length)}')
barcodeFile=$(echo $a | tr " " "\n" | egrep "csv")
popmap=$(echo $a | tr " " "\n" | egrep "txt")
renzym=$(echo $a | tr " " "\n" | egrep '\-r' | awk '{print substr($0,3,length)}')
quality_threshold=$(echo $a |  tr " " "\n" | egrep '\-s' | awk '{print substr($0,3,length)}' )
truncate_length=$(echo $a | tr " " "\n" |  egrep '\-t' | awk '{print substr($0,3,length)}')
window_width=$(echo $a | tr " " "\n" | egrep '\-w' | awk '{print substr($0,3,length)}')
depth_stack=$(echo $a | tr " " "\n" | egrep '\-d' | awk '{print substr($0,3,length)}')
dist_stacks=$(echo $a | tr " " "\n" | egrep '\-m' | awk '{print substr($0,3,length)}')
dist_sec_reads=$(echo $a | tr " " "\n" | egrep '\-n' | awk '{print substr($0,3,length)}')
mother=$(echo $a | tr " " "\n" | egrep '\-x' | awk '{print substr($0,3,length)}')
father=$(echo $a | tr " " "\n" | egrep '\-y' | awk '{print substr($0,3,length)}')

if [[ "${analysis}" == "1" ]] && [[ "${data}" == "1" ]]
    then
        inputFile=$(echo $a | tr " " "\n" | egrep "fq|gz")
        paired=false
fi

if [[ "${analysis}" == "1" ]] && [[ "${data}" == "0" ]]
    then
        inputFile1=$(echo $a | tr " " "\n" | egrep "fq|gz" | egrep "forward|R1")
        inputFile2=$(echo $a | tr " " "\n" | egrep "fq|gz" | egrep "reverse|R2")
fi

if [[ "${analysis}" == "0" ]] && [[ "${data}" == "0" ]] 
    then 
       ref_genome_File=$(echo $a | tr " " "\n" | egrep '\-g' | awk '{print substr($0,3,length)}')
       inputFile1=$(echo $a | tr " " "\n" | egrep "fq|gz" | egrep "forward|R1")
       inputFile2=$(echo $a | tr " " "\n" | egrep "fq|gz" | egrep "reverse|R2")
       ref_genome=true
fi

if [[ "${analysis}" == "0" ]] && [[ "${data}" == "1" ]] 
    then
       ref_genome_File=$(echo $a | tr " " "\n" | egrep '\-g' | awk '{print substr($0,3,length)}')
       inputFile=$(echo $a | tr " " "\n" | egrep "fq|gz")
       ref_genome=true
       paired=false
fi

#check if all the needed files are present, if not the pipeline is aborted.
missing=false
for pipelineFile in \
	Highway_IBEDs_pipeline.sh \
	prep_IBEDs_pipeline.sh \
        initial_reads_IBEDs_pipeline.R\
	ustacks_IBEDs_pipeline.py\
        count_ustacks_values_IBEDs_pipeline.sh\
        ustacks_values_IBEDs_pipeline.R\
        sstacks_IBEDs_pipeline.py\
        count_sstacks_values_IBEDs_pipeline.sh\
        sstacks_values_IBEDs_pipeline.R
	do
	if ! [ -f "${pipelineFile}" ]
		then
		        echo ${pipelineFile}" does not exist." 
			missing=true
                        sleep 2
	fi
done 
                if ${missing}
 		    then
                        sleep 2
	                echo "The IBEDs STACK pipeline is aborted."
	                echo " "			
	                while true; do
				read -p "Press enter to exit " enter
				case $enter in
					("")exit 1;;
					*) echo "Please press enter to exit";;
				esac
			done
	        fi

if [[ "${ref_genome}" == "true" ]] && [[ "${paired}" == "true" ]]
	then
	echo "Starting reference based analysis on paired-end data."
	echo " "
        bash Highway_IBEDs_pipeline.sh ${inputFile1} ${inputFile2} ${barcodeFile} ${popmap} ${a_path} ${renzym} ${truncate_length} ${quality_threshold} ${window_width} ${dist_stacks} ${depth_stack} ${dist_sec_reads} ${ref_genome} ${paired} ${mother} ${father} ${ref_genome_File} 1

fi
if [[ "${ref_genome}" == "true" ]] && [[ "${paired}" == "false" ]]
	then 
	echo "Starting reference based analysis on single-end data."
	echo " "
        bash Highway_IBEDs_pipeline.sh ${inputFile} ${barcodeFile} ${popmap} ${a_path} ${renzym} ${truncate_length} ${quality_threshold} ${window_width} ${dist_stacks} ${depth_stack} ${dist_sec_reads} ${ref_genome} ${paired} ${mother} ${father} ${ref_genome_File} 2

fi
if [[ "${ref_genome}" == "false" ]] && [[ "${paired}" == "false" ]]
	then
	echo "Starting de novo based analysis on single-end data."
	echo " "
	bash Highway_IBEDs_pipeline.sh ${inputFile} ${barcodeFile} ${popmap} ${a_path} ${renzym} ${truncate_length} ${quality_threshold} ${window_width} ${dist_stacks} ${depth_stack} ${dist_sec_reads} ${ref_genome} ${paired} ${mother} ${father} 3

fi
if [[ "${ref_genome}" == "false" ]] && [[ "${paired}" == "true" ]]
        then
        echo "Starting de novo based analysis on paired-end data."
	echo ""
      	bash Highway_IBEDs_pipeline.sh ${inputFile1} ${inputFile2} ${barcodeFile} ${popmap} ${a_path} ${renzym} ${truncate_length} ${quality_threshold} ${window_width} ${dist_stacks} ${depth_stack} ${dist_sec_reads} ${ref_genome} ${paired} ${mother} ${father} 4

fi

sleep 5
trap SIGINT
