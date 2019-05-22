#sed one-liners
#dg

################################################################################

#sed
#switch the ID and identifier field output.

head all_ORFs.fasta
#>k79_1_1 # 3 # 236 # -1 # ID=1_1;partial=11;start_type=Edge;

#3 elements to pattern match, replace (switch order) by backreferencing
sed 's/\(k[0-9]*_[0-9]*_[0-9]*\) \(.*\) \(ID=[0-9]*_[0-9]*\)/\3 \2 \1/' all_ORFs.fasta > all_ORFs_idswitched.fasta

head all_ORFs_idswitched.fasta
#>ID=1_1 # 3 # 236 # -1 # k79_1_1;partial=11;start_type=Edge;

#replace >lcl|WK161157.1_asd_JWR62445.1_1 with for each line in a file JWR62445.1
#3 groups, backreplace with second group matching part of interest
sed 's/\(lcl|WK161157.1_cds_\)\([A-Z]*[0-9]*.[0-9*]\)\(_[0-9]*\)/\2/' input.txt > output.txt

################################################################################

#awk

# filter fastq file by list of read names
awk 'NR==FNR{hash[$1];next} $1 in hash{print; nr[NR+1]; nr[NR+2]; nr[NR+3]; next} NR in nr' read_ids.txt all_reads.fastq > subset_reads.fastq
# populate hash table with file one read name
# search each read name in second file
# print the line where match occurs, as well as following three lines

# filter fastq by read names, "convert" to fasta
awk 'NR==FNR{hash[$1];next} $1 in hash{print ">" substr($0, 2); nr[NR+1]; next} NR in nr' read_names.txt all_reads.fastq > subset.fasta

# filter (a non-fasta) fasta file according to length using awk. this works if sequences are a single line after the header (not actually fasta format.)
awk '(/^[A-Z]/ && length($0)>50 && length($0)< 500) {print x; print}; {x=$0}' input.fasta
# match sequence lines by A-Z and length > 50 and length < 500
# print line immediately before matched line (i.e., fasta header) and current line ("print x, print")
# current line is stored in variable x, so when next line is read, previous line is still available in x variable.

# filter fasta format by length. difference is that no line is greater than 60 characters (i.e., sequences are split into new lines). currently set to filter between 450 and 600, change numbers as necessary
awk '$0 ~ ">" { if (c > 450 && c < 600) {print x, seq} c=0; x = $0; seq = ""} $0 !~ ">" {c+=length($0); seq = seq"\n"$0} END {exit}' contigs.fasta > contigs_filtered.fasta
# if line matches ">" (i.e., fasta header is found) do:
    # (skipped until variables set) if counter (c) is > 450 and < 600, print the line (i.e., fasta header) and the sequence associated with that header.
# reset counter, reassign x as current header, reset sequence
# if there is no ">" in the line
    # add the length of the line to the counter (i.e., total the sequence length for each sequence),
    # concatenate line of current sequence to the next line of sequence with a line new line in between (keep sequence as one unit).
# end rules exits awk

# pull reads from fastq file from file of desired line numbers. useful for randomly selecting subset of reads.
# generate file of "random" indices from R first. each index points to a line with a header. this file has 1000 numbers from 1:100000. set.seed in order to have reproducible list (useful for paired end reads).
# set.seed(1);  numbers <- sort(sample.int(1000000, 1000)) *4 + 1; write.table(numbers, "desired_index_reads.txt", sep="\n", quote = FALSE, row.names=FALSE, col.names=FALSE)
# populate array a with indices from desired_index_reads.txt (NR==FNR means current record number must equal total record number... i.e., only work on the first file will occur first)
# in the input.fastq file, if the line number (FNR) is in array a, print it as well as the following three lines to output.
awk 'NR==FNR{a[$0]; next} FNR in a{print; getline; print; getline; print; getline; print; next}' desired_index_reads.txt input.fastq > output_subset.fastq

# takes mesh clust output and fasta file of sequences (i.e., input for meshclust) and returns only representative sequences from clust output
# first file: only search representative sequences (i.e., lines with * at the very end)
# make hash table of representative sequence header (NR=FNR ensures only done on first file)
# if x in hash, print x and sequence
# assign x to header (contains ">")
# assign seq to all following lines that don't contain ">" until another header line is reached
# once header line is reached, print the previous header and sequence before repopulating variables
awk '/\*$/, NR==FNR{hash[$3]; next} $1 ~ ">" {if (x in hash) {print x, seq}; x = $1; seq = ""} $1 !~ ">" {seq=seq"\n"$1}' meshclust_output.clstr contigs.fasta > representative_sequences.fasta

# match the header line
# if c is greater than zero, print it to the file with line break.
# reset c once you hit the new header
# for every line following a header (i.e., sequence line), count the number of characters
# when the script is done, print the count (needed to print length of last contig)
# output is length of contigs by line. 
awk '$0 ~ ">" {if  (c > 0) {print c} c=0} $0 !~ ">" {c+=length($0)} END {print c}' contigs.fa > length_counts.txt

