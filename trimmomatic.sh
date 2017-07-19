#!/bin/bash

#July 19 2017 - Daniel Giguere
#Run Trimmomatic to remove poor N-score reads and also the last couple of bases for each file in
# a given working directory

#setup path to data
DATA="/Volumes/data/suncor/data/"

#setup path to trimmomatic.jar file
TRIM="/home/dgiguer/Trimmomatic-0.36/trimmomatic-0.36.jar"

#make an output directory if it doesn't exist
mkdir -p trimmomatic_output

#run trimmomatic
for f in $DATA/*fastq.gz; do
  #get name of file
  B='basename $f'
  NAME='echo $B'

  #run trimmomatic on each f
  nohup java -jar $TRIM SE [-threads 32] $f trimmomatic_output/$NAME.trim.out LEADING:5 CROP:73
done
