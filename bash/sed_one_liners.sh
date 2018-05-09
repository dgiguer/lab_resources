#sed one-liners
#dg

################################################################################

#switch the ID and identifier field output.

head all_ORFs.fasta
#>k79_1_1 # 3 # 236 # -1 # ID=1_1;partial=11;start_type=Edge;

#3 elements to pattern match, replace (switch order) by backreferencing
sed 's/\(k[0-9]*_[0-9]*_[0-9]*\) \(.*\) \(ID=[0-9]*_[0-9]*\)/\3 \2 \1/' all_ORFs.fasta > all_ORFs_idswitched.fasta

head all_ORFs_idswitched.fasta
#>ID=1_1 # 3 # 236 # -1 # k79_1_1;partial=11;start_type=Edge;

################################################################################
