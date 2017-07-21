#!/bin/bash

#July 19 2017 - Daniel Giguere
#Run Trimmomatic to remove poor N-score reads at beginning of sequence and last couple of bases for each file in wd

#set up a directory called trim_output before running in the current working directory

#run trimmomatic
for f in /Volumes/data/suncor/data/*fastq.gz #change where files are located
do
#get filename
B=`basename $f`
NAME=`echo $B`
#run trimmomatic with 16 threads
#change LEADING/CROP as needed, look at trimmomatic manual
java -jar /Volumes/bin/Trimmomatic-0.36/trimmomatic-0.36.jar SE -threads 16 $f trim_output/$NAME.out LEADING:5 CROP:73
done
