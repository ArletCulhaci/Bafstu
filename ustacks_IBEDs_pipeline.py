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
    f  = open(gsi_barcode, "r")
    reader = csv.reader(f)
    for row in reader:
        ls_sampleIDs.append(row[0][6:]) #gets remaining string after 6 indices, barcode(5 bp). 
    return ls_sampleIDs

def executeCommand(ec_sampleIDs, ec_ab_path, ec_output_dir, ec_porsingle, ec_dist_stacks, ec_depth_stack):
    os.system("mkdir " + ec_ab_path + "/" + ec_output_dir + "/stacks")
    for x in range(len(ec_sampleIDs)):
        if ec_porsingle == "true":
            command1 = "ustacks -f " + ec_ab_path + "/"  + ec_output_dir + "/samples/"  + str(ec_sampleIDs[x]) + ".1.fq.gz " + " -o " + ec_ab_path + "/" + ec_output_dir  + "/stacks/ -i " +  str(x) + " -m " + str(ec_depth_stack) + " -M " + str(ec_dist_stacks) + " -d -H --disable-gapped -p 20 2>" + ec_ab_path + "/" + ec_output_dir + "/stacks/ustacks_" + str(ec_sampleIDs[x]) + ".log"
            os.system(command1)
        else:
            command1 = "ustacks -f " + ec_ab_path + "/"  + ec_output_dir + "/samples/"  + str(ec_sampleIDs[x]) + ".fq.gz " + " -o " + ec_ab_path + "/" + ec_output_dir  + "/stacks -i " +  str(x) + " -m " + str(ec_depth_stack) + " -M " + str(ec_dist_stacks) + " -d -H --disable-gapped -p 20 2>" + ec_ab_path + "/" + ec_output_dir + "/stacks/ustacks_" + str(ec_sampleIDs[x]) + ".log"
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

    
	    
