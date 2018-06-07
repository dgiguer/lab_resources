# Generate a coloured compositional principal components analysis (PCA) biplot
# DG

# needed for coloredBiplot
library(compositions)

# load read count table in, samples by columns and features by rows
d <- read.table("data/count_tables/all_counts_fr.txt", sep = "\t", header=TRUE, quote = "", stringsAsFactors=FALSE, check.names=FALSE)

# remove sparse features (sum of all samples less than 10)
# specify columns for rowSums if taxonomy (or text) column present
d.f <- d[which(rowSums(d) > 10),]

# remove zeros for log ratio
# this is "quick and dirty" way. another option, Bayesian multiplicative zero replacement is `cmultRepl` in `zCompositions` package.
d.n0 <- d.f + 0.5

# transpose for correct orientation for calculating centered log ratio
d.t <- t(d.n0)

# calculate centered log ratio. log of count minus the mean log of all counts from a sample.
d.clr <- (log(d.t) - rowMeans(log(d.t)))

# generate principal components analysis object
d.pcx <- prcomp(d.clr)

# generate vector of periods that is the length of the number of features. this helps make the plot less cluttered.
points <- c(rep(".", length(dimnames(d.pcx$rotation)[[1]])))

# calculate variance
x.var <- sum(d.pcx$sdev ^ 2)
PC1 <- paste("PC 1 Variance: %", round(sum(d.pcx$sdev[1] ^ 2) / x.var * 100, 1))
PC2 <- paste("PC 2 Variance: %", round(sum(d.pcx$sdev[2] ^ 2) / x.var*100, 1))

# make colour vector for each column
# in this case, the first 3 columns are condition 1, and the following 3 columns are condition 2. first 3 samples will be coloured red, following three are coloured blue.
cols <- c(c(rep("indianred1", 3)), c(rep("skyblue2", 3)))

# optional: generate a pdf
# pdf("descriptive_name.pdf")

# xlabs.col colours the sample names
# change col if feature points are too dark
coloredBiplot(d.pcx, xlabs.col=colour, main = "Compositional PCA biplot with colours!", col = c("grey20", rgb(0,0,0,0.1)), var.axes=FALSE, xlab = PC1,
      ylab = PC2, ylabs=points)

#optional: generate a pdf
#dev.off()
