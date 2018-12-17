#!/usr/bin/env R

#dec 17 2018
#Daniel Giguere

# merge all the count tables in the current directory and generate a summary
# usage: Rscript ~/merge_counts.R
# all count files from htseq must have sample number follow by "-count" to be included in this summary.

# get all files of counts. change "-count" if necessary
files <- grep("-count", dir(), value =TRUE)

#make list
df <- list()

# make list of dataframes of each count file
for (i in seq(files)) {
    # these should all be the same length assuming you count from the same gff file
    df[[i]] <- read.table(files[i], sep = "\t", stringsAsFactors=FALSE, quote = "")
}

# initialize dataframe to length of count file, and width of number of iels
m <- data.frame(matrix(0, ncol = max(seq(df)), nrow = length(df[[1]]$V2)))

# rename rows to contigs names and columns to sample numbers
rownames(m) <- df[[1]]$V1
colnames(m) <- seq(df)

# populate the dataframe with the counts from every file
for (i in seq(df)){
    m[,i] <- df[[i]]$V2
}

# generate summary file using stats on bottom
summary <- m[(dim(m)[1]-4):(dim(m)[1]),]

#remove summary information from counts table
m <- m[-((dim(m)[1]-4):(dim(m)[1])),]

#write tables
write.table(summary, "summary_counts.txt", sep = "\t", col.names=TRUE, row.names=TRUE, quote = FALSE)

#col.names=NA adds space for rownames as column
write.table(m, "count_table_merged.txt", sep = "\t", col.names=NA, row.names=TRUE, quote = FALSE)
