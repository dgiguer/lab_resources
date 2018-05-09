# September 7 2017
# Daniel Giguere

# Search for duplicates in large text file (diamond output) with python and hashes for speed.
# Currently set up to check for duplicates in first column only.
# Make sure target file is encoded F-8 and Unix LF.
#
# put in working directory of .m8 files and pass output to text file:
# python duplicatecheck.py >> duplicate_output.txt
#

import collections
import hashlib
import re
import glob

#make dictionary list
d = collections.defaultdict(list)

# choose file to search for duplicates (testx.txt)
# 'r' = read only

# generate list of files
files = glob.glob('*.m8')

for file in files:
    with open(file, 'r') as datafile:
        for line in datafile:
            
            #split by tab
            line = re.split('\t', line)
            
            #concatenate read id and score
            read = line[0] + " " + line[-1]

            #create hash
            id = hashlib.sha256(read).digest()
            
            #use first 2 bytes as key, store rest in value.
            k = id[0:30]
            v = id[30:]


            #check if any hashes match
            if v in d[k]:
            
                print "equal best hit found in", file, ":", read
                
            else:
                #merge byte back together to be stored in list d.
                d[k].append(v)
