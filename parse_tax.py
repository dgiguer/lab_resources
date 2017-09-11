# September 11 2017
# Daniel Giguere

# Parse through annotations to get taxonomic identifiers from inside brackets.

import re
import csv

# choose file
# r mean read only (just in case)

taxList = []
with open('summedcountsann.txt', 'r') as f:
    #skip header row
    next(f)
    for line in f:

        # append list with everything found inside of '[]' in all lines of the file.
        taxList.append(re.findall("\[(.*?)\]", line))


# write the list to a .txt file as one column
# this replaces or writes a file if its not found
with open('taxList.txt', 'w') as output:

    #load csv writer
    writer = csv.writer(output)

    # write each value as its own row
    for val in taxList:
        writer.writerow([val])
