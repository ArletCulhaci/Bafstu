"""
name: Arlet Culhaci
Date: 01-nov-2018
Function: invoke sstacks module
Version 1: steffi
"""
import csv
import os
samples = []
f  = open("../../barcodes.csv", "rb")
reader = csv.reader(f)
for row in reader:
    samples.append(row[0][6:])


for x in range(len(samples)):
    command1 = "sstacks -c ./stacks_steffi_ac_1_nov/ -s ./stacks_steffi_ac_1_nov/" + str(samples[x]) + " -o ./stacks_steffi_ac_1_nov/ -p 5 2> ./stacks_steffi_ac_1_nov/sstack_1_nov_" + str(samples[x]) + "_steffi.log" 
    os.system(command1)

