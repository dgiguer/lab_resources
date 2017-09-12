#!/usr/bin/env python
# September 8 2017

# Daniel Giguere

# shell loop to check all files in directory for duplicate hits

# make sure doublecheck.py is in the cwd
# make sure the file dupcheck exists in the directory
for f in *.m8
do
python doublecheck.py >> doublecheck_output.txt
done
