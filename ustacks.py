"""
Name: Arlet Culhaci
Date: 4-okt-2018
Function: invoke ustacks module
Version 2: iplemented in pipeline 
"""

import csv
import os
import sys

def getSampleID(gsi_barcode, gsi_path):
    ls_sampleIDs = []
    print(gsi_path)
    print(gsi_barcode) 
    f  = open(gsi_path + "/" +  gsi_barcode, "rb")
    reader = csv.reader(f)
    for row in reader:
        ls_sampleIDs.append(row[0][6:]) #gets remaining string after 6 indices, barcode(5 bp). 
    return ls_sampleIDs

def executeCommand(ec_sampleIDs, ec_ab_path, ec_output_dir, ec_porsingle):
    for x in range(len(ec_sampleIDs)):
	if ec_porsingle == "true":
		#print(ec_ab_path + "/" + ec_output_dir + "/" + str(ec_sampleIDs[x]) + ".1.fq.gz")
        	command1 = "ustacks -f " + ec_ab_path + "/" + ec_output_dir + "/"  + str(ec_sampleIDs[x]) + ".1.fq.gz " + " -o " + ec_ab_path + "/" + ec_output_dir + "/stacks_" + "Clean_$DATE-$N "  + "-i " +  str(x) + " -m 3 -M 4 -p 5"
		#print(command1)
		os.system(command1)
	else:
		#print(ec_ab_path + "/" + ec_output_dir + "/" + str(ec_sampleIDs[x]) + ".fq.gz")
        	command1 = "ustacks -f " + ec_ab_path + "/"  + ec_output_dir + "/"  + str(ec_sampleIDs[x]) + ".fq " + " -o " + ec_ab_path + "/" + ec_output_dir  + " -i " +  str(x) + " -m 3 -M 4 -p 5"
		#print(command1)
		os.system(command1)
        #print(command1)
        #os.system(command1)

def main():
    print(sys.argv)
    fl_barcode = sys.argv[1]
    print(fl_barcode)
    ab_path = sys.argv[2]
    print(ab_path)
    output_dir = sys.argv[3]
    print(output_dir)
    porsingle = sys.argv[4]
    print(porsingle)
    ls_sampleIDs = getSampleID(fl_barcode, ab_path)
    executeCommand(ls_sampleIDs, ab_path, output_dir, porsingle)

main()

    
	    
