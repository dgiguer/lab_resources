# September 7 2017
# Daniel Giguere

# Search for duplicates in large text file (diamond output) with python and hashes for speed.
# Currently set up to check for duplicates in first column only.
# Make sure target file is encoded F-8 and Unix LF.

# to use:
# put in directory of choice, and put output to txt file:
# python duplicatecheck.py > duplicate_output.txt

import collections
import hashlib
import re
import glob

#make dictionary list
d = collections.defaultdict(list)

# 'r' = read only

# generate list of files in cwd.
files = glob.glob('*.m8')

for file in files:
    with open(file, 'r') as datafile:
        for line in datafile:

            #split by tab
            line = re.split('\t', line)

            #create hash for first column. choose column number (python
            #starts at 0)
            id = hashlib.sha256(line[0]).digest()

            #use first 2 bytes as key, store rest in value.
            k = id[0:2]
            v = id[2:]

            #check if any hashes match
            if v in d[k]:
                print "duplicates found in", file, ":", line[0]
            else:
                #merge byte back together to be stored in list d.
                d[k].append(v)
