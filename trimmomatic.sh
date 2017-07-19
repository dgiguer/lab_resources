#!/bin/bash

#July 19 2017 - Daniel Giguere
#Run Trimmomatic to remove poor N-score reads and also the last couple of bases for each file

#set up a directory called trim_output before running.

#run trimmomatic
for f in /Volumes/data/suncor/data/*fastq.gz
do
#get filename
B=`basename $f`
NAME=`echo $B`
#run trimmomatic with 16 threads
java -jar /Volumes/bin/Trimmomatic-0.36/trimmomatic-0.36.jar SE -threads 16 $f trim_output/$NAME.out LEADING:5 CROP:73
done
