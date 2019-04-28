"""
name: Arlet Culhaci
Date: 01-nov-2018
Function: invoke sstacks module
Version 1: steffi
"""
import os
import sys
import csv
def getSampleID(gsi_barcode, gsi_path):
    ls_sampleIDs = []
    print(gsi_path)
    print(gsi_barcode)
    f  = open(gsi_barcode, "r")
    reader = csv.reader(f)
    for row in reader:
        ls_sampleIDs.append(row[0][6:]) #gets remaining string after 6 indices, barcode(5 bp). 
    return ls_sampleIDs

def executeCommand(ec_sampleIDs, ec_ab_path, ec_output_dir, ec_data_type):
    for x in range(len(ec_sampleIDs)):
        if ec_data_type == "true":
            command1 = "sstacks -c " + ec_ab_path + "/" + ec_output_dir + " -s " + ec_ab_path + "/" + ec_output_dir + "/" + str(ec_sampleIDs[x]) + ".1 -o " + ec_ab_path + "/" + ec_output_dir +" -p 20 2> " + ec_ab_path + "/" + ec_output_dir + "/" + "sstack_" + str(ec_sampleIDs[x]) + ".log"
            os.system(command1)
        else:
            command1 = "sstacks -c " + ec_ab_path + "/" + ec_output_dir + " -s " + ec_ab_path + "/" + ec_output_dir + "/" + str(ec_sampleIDs[x]) + " -o " + ec_ab_path + "/" + ec_output_dir +" -p 20 2> " + ec_ab_path + "/" + ec_output_dir + "/" + "sstack_" + str(ec_sampleIDs[x]) + ".log"
            os.system(command1)


def main():
    fl_barcode = sys.argv[1]
    ab_path = sys.argv[2]
    output_dir = sys.argv[3]
    data_type = sys.argv[4]
    ls_sampleIDs = getSampleID(fl_barcode, ab_path)
    executeCommand(ls_sampleIDs, ab_path, output_dir, data_type)
main()
