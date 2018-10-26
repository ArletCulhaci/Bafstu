"""
Name: Arlet Culhaci
Date: 22-okt-2018
Function: count # loci, reads per loci and snps per loci. 
Version 1:
"""
import profile
import csv
import os
import subprocess
import functools

def main():
    samples = []
    f  = open("Sample_names_for_counting.txt", "r")
    data = f.readlines()
    f.close()
    samples = [str(x).rstrip("\n") for x in data]
    f = open("counts2.txt", "w")
    f.write("# loci, # reads per loci, # snps per loci")
    f.close()

    def cal2(x,y):
        output_nr_reads_stdout = subprocess.check_output("cat " + x + ".forwards.tags.tsv" + " | awk ' $2 == '" + str(y) + "' {print $0}' | wc -l", shell=True )
        output_nr_reads = int(output_nr_reads_stdout.decode('ascii', 'ignore').partition(' ')[0])
        return output_nr_reads

    def calc(x):
        #ls_nr_reads = []
        #append = ls_nr_reads.append
        output_nr_loci_stdout = subprocess.check_output("cat " + x + ".forwards.tags.tsv" + " | awk '{print $2}' | egrep -v 'ustacks' |  uniq | wc -l" , shell=True )
        output_nr_loci = int(output_nr_loci_stdout.decode('ascii', 'ignore').partition(' ')[0])
        ls_nr_reads =  [*map(functools.partial(cal2, x), range(1,output_nr_loci+1))]
        f2 = open("distribution" + x + ".txt", "a")
        f2.write("\n".join([str(i) for i in ls_nr_reads]))
        ls_nr_reads_int = [int(z) for z in ls_nr_reads]
        mean = int(sum(ls_nr_reads_int)) / float(int(output_nr_loci))
        min_ls = min(ls_nr_reads)
        max_ls = max(ls_nr_reads)
        f = open("counts2.txt", "a")
        f.write("\n" + x + "," + str(output_nr_loci) + "," + str(mean) + "," + str(min_ls) + "," + str(max_ls))
        return output_nr_loci_stdout, mean, min_ls, max_ls

    ls_data = [* map(calc, samples)]

profile.run('main()')
