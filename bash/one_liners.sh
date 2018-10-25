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

# populate hash table with file one read name
# search each read name in second file
# print the line where match occurs, as well as following three lines
awk 'NR==FNR{hash[$1];next} $1 in hash{print; nr[NR+1]; nr[NR+2]; nr[NR+3]; next} NR in nr' read_ids.txt all_reads.fastq > subset_reads.fastq

#extract reads from fastq file, convert to fasta
awk 'NR==FNR{hash[$1];next} $1 in hash{print ">" substr($0, 2); nr[NR+1]; next} NR in nr' read_names.txt all_reads.fastq > subset.fasta

# filter fasta according to length using awk (change lengths accordingly). this works if sequences are a single line (not technically fasta format.)
awk '(/^[A-Z]/ && length($0)>50 && length($0)< 500) {print x; print}; {x=$0}' input.fasta
# match sequence lines by A-Z and length > 50 and length < 500
# print line immediately before matched line (i.e., fasta header) and current line ("print x, print")
# current line is stored in variable x, so when next line is read, previous line is still available in x variable.

# filter for actual fasta format. difference is that no line is greater than 60 characters (i.e., sequences are split into new lines). currently set to filter between 450 and 600, change numbers as necessary
awk '$0 ~ ">" { if (c > 450 && c < 600) {print x, seq} c=0; x = $0; seq = ""} $0 !~ ">" {c+=length($0); seq = seq"\n"$0} END {exit}' input.fasta > output.fasta
# if line matches ">" (i.e., fasta header is found) do:
    # (skipped until variables set) if counter (c) is > 450 and < 600, print the line (i.e., fasta header) and the sequence associated with that header.
# reset counter, reassign x as current header, reset sequence
# if there is no ">" in the line
    # add the length of the line to the counter (i.e., total the sequence length for each sequence),
    # concatenate line of current sequence to the next line of sequence with a line new line in between (keep sequence as one unit).
# end rules exits awk
