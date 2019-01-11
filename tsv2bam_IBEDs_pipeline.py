"""
name: Arlet Culhaci
Date: 01-nov-2018
Function: invoke sstacks module
Version 1: steffi
"""
import csv
import os
import sys

def getSampleID(gs_barcodeFile):
    samples = []
    f  = open(gs_barcodeFile, "rb")
    reader = csv.reader(f)
    for row in reader:
        samples.append(row[0][6:])
    return samples

def executeCommand(ec_sampleIDs, ec_ab_path, ec_output_dir):
    for x in range(len(ec_sampleIDs)):
        ec_sampleIDs_2 = str(ec_sampleIDs[x] + ".1")
        command1 = "tsv2bam -P " + ec_ab_path + "/" + ec_output_dir + " -s " + ec_sampleIDs_2  + " -t 8 -R " + ec_ab_path + "/" + ec_output_dir + str(ec_sampleIDs[x]) + "  2> " + ec_ab_path + "/" + ec_output_dir + "/tsv2bam_" + str(ec_sampleIDs[x]) + ".log"
        os.system("cd " + ec_ab_path + "/" + ec_output_dir)
        os.system(command1)
        #print(command1)

def main():
    fl_barcode = sys.argv[1]
    ab_path = sys.argv[2]
    output_dir = sys.argv[3]
    ls_sampleIDs = getSampleID(fl_barcode)
    executeCommand(ls_sampleIDs, ab_path, output_dir)

main()

