
# July 20 2017 - Daniel Giguere
# sum taxa below given abundance cutoff, write a table for later


#read in kaiju sample. fill = TRUE needed to fill in unequal length rows
d <- read.table("B_S1_L004_R1_001.kaiju.out.summary", header=T, sep="\t", stringsAsFactors=FALSE, quote = "", check.names=F, comment.char="", fill=TRUE)

#make sure its in ordr
d <- d[order(d$`%`, decreasing = TRUE),]

#get genera
genus <- d$genus
d$genus <- NULL

#set cutoff (percent reads)
cutoff <- 0.5

#get below and above cutoff
d.bottom <- subset(d, d$`%` < cutoff)
d.top <- subset(d, d$`%` >= cutoff)

#sum below cutoff into one row
d.other <- c(sum(d.bottom$`%`), sum(d.bottom$reads))

#combine top and summed 
d.cut <- rbind(d.top, d.other)

#create col for genera
tempcol <- matrix(c(rep("NA", times = nrow(d.cut))), nrow=nrow(d.cut), ncol=1)
colnames(tempcol) <- "genus"

#merge
d.cut.bind <- cbind(d.cut, tempcol)

#insert genera
d.cut.bind$genus <- c(genus[1:(nrow(d.cut.bind)-1)], "other")

write.table(d.cut.bind, file = "B_S1_L004_bp.txt", quote = FALSE, sep = "\t", row.names = FALSE)

