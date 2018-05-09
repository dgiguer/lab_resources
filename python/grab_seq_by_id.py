#!/usr/bin python

#pull DNA ORF sequences of interest for big ORFS file by ID

import re
with open("node_99_subset_ORF.txt", "r") as file1:
    s = file1.readlines()
#get rid of header
s=s[1:]

#get rid of '\n'
w=[]
for item in s:
    item = item[:-1]
    w.append(item)

#get fasta file
with open("../diamond_output/all_ORFs_idswitched.fasta", "r") as file2:
    fasta = file2.readlines()

#initiate list
sequences = []


#run loop for each ID number and line of the fasta
#if found, append the fasta header + sequence line to sequences
for ind, item in enumerate(w):
    for number, line in enumerate(fasta):
        if item in line:
            #extend sequences by header
            #sequences.append([fasta[number]])
            #start counter
            counter=1
            #when reached next fasta header, break loop and extend sequence lines
            while ">" not in fasta[number + counter][0]:
                counter += 1
            else:
                #extend by line after fasta header to line before next fasta header
                #need to join the list of sequences as string so we can write it to a file (can't ele to file if ele is a list)
                sequences.extend([fasta[number], ''.join(fasta[(number + 1):(number + counter - 1)])])
                print(item)
                break

#write to file
with open("nodes_sequences.txt", "w+") as z:
    for ele in sequences:
        z.write(ele)
