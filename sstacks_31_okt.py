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
    f  = open(gsi_barcode, "rb")
    reader = csv.reader(f)
    for row in reader:
        ls_sampleIDs.append(row[0][6:]) #gets remaining string after 6 indices, barcode(5 bp). 
    return ls_sampleIDs

def executeCommand(ec_sampleIDs, ec_ab_path, ec_output_dir):
    for x in range(len(ec_sampleIDs)):
        command1 = "sstacks -c " + ec_ab_path + "/" + ec_output_dir + " -s " + ec_ab_path + "/" + ec_output_dir + "/" + str(ec_sampleIDs[x]) + " -o " + ec_ab_path + "/" + ec_output_dir +" -p 5 2> " + ec_ab_path + "/" + ec_output_dir + "/" + "sstack_" + str(ec_sampleIDs[x]) + ".log"
        #print(command1)
        os.system(command1)

def main():
    print(sys.argv)
    fl_barcode = sys.argv[1]
    print(fl_barcode)
    ab_path = sys.argv[2]
    print(ab_path)
    output_dir = sys.argv[3]
    print(output_dir)
    ls_sampleIDs = getSampleID(fl_barcode, ab_path)
    executeCommand(ls_sampleIDs, ab_path, output_dir)
main()
