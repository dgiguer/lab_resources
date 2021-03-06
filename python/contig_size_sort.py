#!/usr/bin/env python

#jan 23 2018
#daniel giguere

#take contigs from final.contigs.fa from megahit output and sorts by size (less or greater than 1000 bp)

#each contig has description of one line, and is followed by one line of sequence. Sort based on if length of the sequence is greater than 1000.
#descriptor line contains the string "len=x" to describe length of sequence line that immediately follows, this is what's used to get length of contigs.

import re

#change file name if needed
with open('subset_megahitoutput.txt', 'r') as file:
    s = file.readlines()
    b = []
    y = []
    #enumerate will count line numbers and provide index for extending lists
    for ind, line in enumerate(s):
        #only search the right lines (descriptor lines start with ">")
        if ">" in line[0]:
            #get length by regex
            m = re.search("len=[0-9]+", line)
            #convert to str
            match = m.group(0)
            #get length as integer by splitting on '='
            length = int(match.split("=")[1])
            #decision tree if number is greater or less than x
            x=1000
            #if integer is less than x, print line and line+1 (descriptor, and sequence) to separate lists
            if length < x:
                b.extend([s[ind], s[ind+1]])
            else:
                y.extend([s[ind], s[ind+1]])

#write the lists to files.
with open('big_contigs.txt', 'w+') as f:
    for ele in y:
        f.write(ele)

with open('small_contigs.txt', 'w+') as z:
    for ele in b:
        z.write(ele)
