#!/usr/bin/env python

#count kmers in fasta file
#longer the kmers, more RAM and time it takes.

#to turn off printing index for files, put a hashtag in front of 'print(ind)'

#usage for 5-mer
#copy+paste function into python
#count_kmer('filename.txt', 'outputname.txt', 5)

#future: add ability to interpret I/O/kmersize directly from command line

def count_kmer(file, output, num):
    with open(file, "r") as infile, open(output, "w+") as w:
        kmer_dict = {}
        #sequence line counter (we want to start on 2, divisible by 4)
        read = 2
        for ind, line in enumerate(infile):
            #only count kmers for lines that are sequences(every fourth line start on line 2)
            #line counter
            #kmer counter
            read += 1
            start = 0
            end = num
            #print ind to show status
            print(ind)
            if read % 4 == 0:
                sequence = line.strip()
                for i in range(len(sequence) - end + 1):
                    #check to see if kmer in dict
                    if not (sequence[start:end] in kmer_dict):
                        kmer_dict[sequence[start:end]] = 0
                    #add one to kmer count
                    kmer_dict[sequence[start:end]] += 1
                    start += 1
                    end += 1
        for key in sorted(kmer_dict):
            w.write(key + "\t" + str(kmer_dict[key]) + "\n")
