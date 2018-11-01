"""
name: Arlet Culhaci
Date: 01-nov-2018
Function: invoke sstacks module
Version 1:
"""
import csv
import os
samples = []
f  = open("../barcodes.csv", "rb")
reader = csv.reader(f)
for row in reader:
    samples.append(row[0][6:])


for x in range(len(samples)):
    command1 = "sstacks -c ./stacks_trial7_h_n1_M2.2/ -s ./stacks_trial7_h_n1_M2.2/" + str(samples[x]) + ".forwards  -o ./sstacks_1_nov/ -p 5 2> sstack_1_nov_" + str(samples[x]) + ".log" 
    os.system(command1)

