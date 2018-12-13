#!/bin/bash
cd /home/biolinux/Documents/Arlet_files/git-repos/Bafstu
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
analysis=$(echo $a | awk '{print $1}' )
data=$(echo $a | awk '{print $2}')
echo $a
#echo $analysis
#echo $data
if [[ "${analysis}" == "novo" ]] && [[ "${data}" == "single" ]]
    then
        echo "inside"
        quality_threshold=$(echo $a |  tr " " "\n" | egrep '\-s' | awk '{print substr($0,3,length)}' )
        truncate_length=$(echo $a | tr " " "\n" |  egrep '\-t' | awk '{print substr($0,3,length)}')
        window_width=$(echo $a | tr " " "\n" | egrep '\-w' | awk '{print substr($0,3,length)}')
        depth_stack=$(echo $a | tr " " "\n" | egrep '\-d' | awk '{print substr($0,3,length)}')
        dist_stacks=$(echo $a | tr " " "\n" | egrep '\-m' | awk '{print substr($0,3,length)}')
        dist_sec_reads=$(echo $a | tr " " "\n" | egrep '\-n' | awk '{print substr($0,3,length)}')
        inputFile=$(echo $a | tr " " "\n" | egrep "fq")
        a_path=$(echo $a | tr " " "\n" | egrep '\-f' | awk '{print substr($0,3,length)}')
        barcodeFile=$(echo $a | tr " " "\n" | egrep "csv")
        popmap=$(echo $a | tr " " "\n" | egrep "txt")
        renzym=$(echo $a | tr " " "\n" | egrep '\-r' | awk '{print substr($0,3,length)}')
        #echo ${quality_threshold}
	#truncate_length=$(echo $a | awk '{print $7}')
	#quality_threshold=$(echo $a | awk '{print $8}')
        #window_width=$(echo $a | awk '{print $9}')
        #depth_stack=$(echo $a | awk '{print $10}')
        #dist_stacks=$(echo $a | awk '{print $11}')
        #dist_sec_reads=$(echo $a | awk '{print $12}')
        paired=false
fi
#echo $truncate_length
echo "test"
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
        sstacks_values_IBEDs_pipeline.R\
        tsv2bam_IBEDs_pipeline.py
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

# asking user input
zenity  --info --title="Pipeline" --text="Be aware to blast a few reads on the full NCBI database, in order to find any form of contamination in your dataset." 
#while true; do

 #   read -p "Do you have a reference genome? " yn

  #  case $yn in

   #     [Yy]* )                 
    #            ref_genome=true     
     #           break;;

      #  [Nn]* )                 
       #         break;;

        #* ) echo "Please answer yes or no.";;

   # esac

#done
#while true; do

 #   read -p "Do you have paired data? " yn

  #  case $yn in

   #     [Yy]* )
    #            break;;

     #   [Nn]* )
#		paired=false
 #               break;;

  #      * ) echo "Please answer yes or no.";;

   # esac

#done
#barcodeFile=$(zenity --file-selection --title="Choose a barcode file")
#read -p "Enter the absolute path to the directory containing the input files: " a_path
#a_path=$(zenity  --file-selection --title="Choose a directory" --directory)
#a_path=$((zenity  --file-selection --title="Choose a directory" --directory ))
#if the user wants to change the default parameters, ask for new parameters.
#while true; do

 #   read -p "Do you want to change the default parameters: " yn

  #  case $yn in

       # [Yy]* ) 
	#	read -p "Set your restriction enzyme: " renzym
	#	echo ""                
	#	read -p "Set truncate length: " truncate_length
         #       echo " "
          #      read -p "Set window width: " window_width
	#	echo ""
	#	read -p "Set Phred quality threshold: " quality_threshold
	#	echo ""
	#	read -p "Set the maximum allowed mismatches between similar stacks: " dist_stacks
	#	echo ""
	#	read -p "Set the minimum number of reads to form a stack (depth): " depth_stack
	#	echo ""
	#	read -p "Set the maximum allowed mismatches between the stack and secondary reads (N+1): " dist_sec_reads
	#	echo ""
	#	echo "Using custom parameters."
	#	echo "Restriction enzyme is set to ${renzym}"
        #        echo "Truncating reads to ${truncate_length} bp."
         #       echo "Using a sliding window of ${window_width} bp to asses te quality of the reads. "
          #      echo "The Phred quality threshold is set to ${quality_threshold}"
          #      echo "The maximum allowed mismatches between stacks is ${dist_stacks}"
           #     echo "The minimum number of reads to form staks (depth) is ${depth_stack}"
            #    echo "The maximum allowed mismatches between stacks and secondary reads is N + ${dist_sec_reads}"

#	        break;;

 #       [Nn]* )                 
#		echo "Using defaults parameters."
#		echo "Restriction enzyme is set to ${renzym}"
 #               echo "Truncating reads to ${truncate_length} bp."
  #              echo "Using a sliding window of ${window_width} bp to asses te quality of the reads. "
   #             echo "The Phred quality threshold is set to ${quality_threshold}"
    #            echo "The maximum allowed mismatches between stacks is ${dist_stacks}"
     #           echo "The minimum number of reads to form staks (depth) is ${depth_stack}"
#		echo "The maximum allowed mismatches between stacks and secondary reads is N + ${dist_sec_reads}"
#		break;;

 #       * ) echo "Please answer yes or no.";;

  #  esac

#done
if [[ "${ref_genome}" == "true" ]] && [[ "${paired}" == "true" ]]
	then
	echo "Starting reference based analysis on paired-end data."
	echo " "
	read -p "Enter the .fasta or .fa file of yout reference genome: " ref_fasta
	echo ""
        files=$(zenity --file-selection --multiple)
        inputFile1=$(echo ${files} | cut -d"|" -f1)
        inputFile2=$(echo ${files} | cut -d"|" -f2)
	read -p "Enter both input files: " inputFile1 inputFile2
fi
if [[ "${ref_genome}" == "true" ]] && [[ "${paired}" == "false" ]]
	then 
	echo "Starting reference based analysis on single-end data."
	echo " "
        read -p "Enter the .fasta or .fa file of yout reference genome: " ref_fasta
        echo ""
        inputFile=$(zenity --file-selection --title="Choose a barcode file")
        #read -p "Enter your input file: " inputFile

fi
if [[ "${ref_genome}" == "false" ]] && [[ "${paired}" == "false" ]]
	then
	echo "Starting de novo based analysis on single-end data."
	echo " "
        #inputFile=$(zenity --file-selection --title="Choose your input file")
        #read -p "Enter your input file: " inputFile
	bash Highway_IBEDs_pipeline.sh ${inputFile} ${barcodeFile} ${a_path} ${renzym} ${truncate_length} ${quality_threshold} ${window_width} ${dist_stacks} ${depth_stack} ${dist_sec_reads} ${ref_genome} ${paired}

fi
if [[ "${ref_genome}" == "false" ]] && [[ "${paired}" == "true" ]]
        then
        echo "Starting de novo based analysis on paired-end data."
	echo ""
        files=$(zenity --file-selection --multiple)
        inputFile1=$(echo ${files} | cut -d"|" -f1)
        inputFile2=$(echo ${files} | cut -d"|" -f2)
	#read -p "Enter both input files: " inputFile1 inputFile2
      	echo "bash Highway_IBEDs_pipeline.sh ${inputFile1} ${inputFile2} ${barcodeFile} ${a_path} ${renzym} ${truncate_length} ${quality_threshold} ${window_width} ${dist_stacks} ${depth_stack} ${dist_sec_reads} ${ref_genome} ${paired}"

fi

#if [[ "${porsingle}" == "P" ]] || [[ "${porsingle}" == "p" ]]
#	then
#		read -p "Enter both input files: " inputFile1 inputFile2
#		bash Highway_IBEDs_pipeline.sh ${inputFile1} ${inputFile2} ${barcodeFile} ${a_path}
#fi
#if [[ "${porsingle}" == "S" ]] || [[ "${porsingle}" == "s" ]]
#	then 
#		read -p "Enter your input file: " inputFile1
#		bash Highway_IBEDs_pipeline.sh ${inputFile1} ${barcodeFile} ${a_path}
#fi
sleep 10
trap SIGINT
