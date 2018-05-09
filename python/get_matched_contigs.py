#!/usr/bin/env python

#jan 29 2018
#dg

# This script matches predicted ORFs (by Prodigal, in FASTA) to output from Diamond to return only contigs that returned a hit in Diamond.

#all_contigs_translations.m8 is diamond output, there are 94976 hits.
#all_ORFs.fasta are all predicted ORFs dna sequences by prodigal in fasta format.

import re

#open file and read lines
hits = open('all_contigs_translations.m8', 'r')
s = hits.readlines()
names = []

#this will split all columns by the tab separation.
for item in s[0:]:

    #need to have correct amount of variables for each column
    name, accession, score1, score2, score3, score4, score5, score6, score7, score8, score9, score10 = item.strip().split("\t")

    #only append the names because thats all we care about
    names.append(name)

#check to make sure all are extracted
len(names)

#read in all contigs
contigs = open('../output/all_ORFs.fasta', 'r')
a = contigs.readlines()

#initialize lists
b=[]
y=[]
z=[]

#get list of indices for each descriptor line of fasta file
for ind, line in enumerate(a):
    if ">" in line[0]:
        z.append(a.index(line))

#For each descriptor line, extend the list of contigs that matched
for ind, line in enumerate(a):
    #only search lines with descriptions
    if ">" in line[0]:
        # #only search lines with descriptions
        # if ">" in line[0]:
        #     z.append(atest.index(line))
        names2 = line.split(" ", 1)
        #take only name and get rid ">" (only take characters after >)
        namesfin = names2[0][1:]
        #if there are in the names, make new list with contigs that were present, or put in list that weren't
        num = z.index(ind)
        #this will give error on last one so the last value needs to be checked manually
        if namesfin in names:
            b.extend([a[(z[num]):(z[num+1])]])
        else:
            y.extend([a[(z[num]):(z[num+1])]])

#the last one is a hit, so i need to extend the last one
b.extend([a[-5:-1]])

#check
len(b)

#the formatting of all_ORFs.fasta affects bowtie. remove the "\n" in between the sequences.

bnew=[]
for item in b:
    #print(item)
    #remove line breaks from middle of sequence
    m = [s.strip("\n") for s in item[1:-1]]
    #create new list of sequence without line breaks in middle of sequences
    bnew.append([item[0], "".join(str(e) for e in m), item[-1]])

#same for unmatches
ynew=[]
for item in y:
    #print(item)
    #remove line breaks from middle of sequence
    m = [s.strip("\n") for s in item[1:-1]]
    #create new list of sequence without line breaks in middle of sequences
    ynew.append([item[0], "".join(str(e) for e in m), item[-1]])

#write the new list of seqeunces to file.
with open('all_matched_contigs.txt', 'w+') as f:
    for ele in bnew:
        #need to join items in each array
        f.write(''.join(ele))

#write the lists to files.
with open('non_matched_contigs.txt', 'w+') as f:
    for ele in ynew:
        #need to join items in each array
        f.write(''.join(ele))
