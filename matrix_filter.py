"""
Author: Arlet CULHACI
Date: 11-01-2018
Subject: Filter markers in qtl matrix
Version: 3
Python 3.7
"""


#from numpy import genfromtxt
#my_data = genfromtxt('matrix_python_test.csv', delimiter=',')

import csv
import os
import subprocess
import sys

def func(f_ab_path, f_matrix):
    with open(f_ab_path + "/" + f_matrix) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter='\t')
        line_count = 0
        double_markers = {}
        counter = 0
        for row in csv_reader:
            #counter += 1
            old_NA = 0
            old_AA = 0
            old_BB = 0
            old_AB = 0
            if line_count == 0:
                index_female = row.index("614_fem_6-11-15_sorted")
                index_male = row.index("614_male_6-11-15_sorted") 
            else:
                if row[index_female] != row[index_male] or row[index_female] and row[index_male] == "A/B":
                    for item in row:
                        if item == "NA":
                            old_NA += 1
                        if item == "A/A":
                            old_AA +=  1
                        if item == "B/B":
                            old_BB += 1
                        if item == "A/B":
                            old_AB += 1
                    total_types = old_AA + old_BB + old_AB
                    old_AA_ratio = old_AA / total_types
                    old_BB_ratio = old_BB / total_types
                    old_AB_ratio = old_AB / total_types
                    if old_NA <= 35:
                        if old_AA_ratio > 0.8 or old_BB_ratio > 0.8 or old_AB_ratio > 0.8:
                            pass
                        else:
                            counter += 1
                            #print(row[0].split(":")[0], line_count)
                            #row.append(str(old_NA))
                            #row.append(str(old_AA))
                            #row.append(str(old_BB))
                            #row.append(str(old_AB))
                            #row.append(str(counter))
                            #row.insert(1, str(counter))
                            naam  = row[0]
                            chrom = row[0].split(":")[0]
                            pos = row[0].split(":")[1]
                            row.insert(1, chrom)
                            row.insert(2, pos)
                            #print(double_markers[row[0]])
                            #double_markers[row[0].split(":")[0]] = row[1:]
                            double_markers[row[0]] = row[1:]
                            #print(double_markers[row[0]])
                    #print(row[index_female] + "-" + row[index_male])
            line_count += 1
            a = (line_count/13300) * 100
            ##print(str(round(a, 2)) + "%")
        with open(f_ab_path + "/filtered_matrix_4.csv", "a",  newline='') as f:
            writer = csv.writer(f)
            for key, value in double_markers.items():
                writer.writerow([key, [x for x in value]])
       # print(double_markers)
        
def main():
    ab_path = sys.argv[1]
    matrix = sys.argv[2]
    func(ab_path, matrix)

main()
