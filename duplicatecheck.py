# September 7 2017
# Daniel Giguere

# Search for duplicates (as strings) in large text file (diamond output) with python.
# Make sure target file is encoded F-8 and Unix LF.

import collections
import hashlib
import re

#make dictionary list
d = collections.defaultdict(list)

#choose file to search for duplicates (testx.txt)
with open('testx.txt', 'r') as datafile:
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
            print "duplicate(s) found:", line[0]
        else:
            #merge byte back together to be stored in list d.
            d[k].append(v)
