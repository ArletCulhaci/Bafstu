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
    f  = open(gsi_barcode, "rb")
    reader = csv.reader(f)
    for row in reader:
        ls_sampleIDs.append(row[0][6:]) #gets remaining string after 6 indices, barcode(5 bp). 
    return ls_sampleIDs

def executeCommand(ec_sampleIDs, ec_ab_path, ec_output_dir, ec_porsingle, ec_dist_stacks, ec_depth_stack):
    for x in range(len(ec_sampleIDs)):
	if ec_porsingle == "true":
                print(ec_sampleIDs[x])
		#print(ec_ab_path + "/" + ec_output_dir + "/" + str(ec_sampleIDs[x]) + ".1.fq.gz")
        	command1 = "ustacks -f " + ec_ab_path + "/"  + ec_output_dir + "/"  + str(ec_sampleIDs[x]) + ".1.fq " + " -o " + ec_ab_path + "/" + ec_output_dir  + " -i " +  str(x) + " -m " + str(ec_depth_stack) + " -M " + str(ec_dist_stacks) + " -H -p 12 2>" + ec_ab_path + "/" + ec_output_dir + "/ustacks_" + str(ec_sampleIDs[x]) + ".log"
		#print(command1)
		os.system(command1)
	else:
		#print(ec_ab_path + "/" + ec_output_dir + "/" + str(ec_sampleIDs[x]) + ".fq.gz")
        	command1 = "ustacks -f " + ec_ab_path + "/"  + ec_output_dir + "/"  + str(ec_sampleIDs[x]) + ".fq " + " -o " + ec_ab_path + "/" + ec_output_dir  + " -i " +  str(x) + " -m " + str(ec_depth_stack) + " -M " + str(ec_dist_stacks) + " -H -p 12 2>" + ec_ab_path + "/" + ec_output_dir + "/ustacks_" + str(ec_sampleIDs[x]) + ".log"
		os.system(command1)

def main():
    fl_barcode = sys.argv[1]
    ab_path = sys.argv[2]
    output_dir = sys.argv[3]
    porsingle = sys.argv[4]
    dist_stacks = sys.argv[5]
    depth_stack = sys.argv[6]
    ls_sampleIDs = getSampleID(fl_barcode, ab_path)
    executeCommand(ls_sampleIDs, ab_path, output_dir, porsingle, dist_stacks, depth_stack)

main()

    
	    
