#!/bin/bash

# July 20 2017 - Daniel Giguere
# remove hyphens from all kaiju.out.summary files in a directory

for f in *.summary
do
awk -F- 'NF<=2' $f > tmp_file && mv tmp_file $f
done
