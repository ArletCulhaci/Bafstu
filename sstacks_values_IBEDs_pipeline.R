args <- commandArgs()
file <- args[6]
dir <- args[7]
library(ggplot2)
library(cowplot)
#First install cowplot!
#library(cowplot)
file_path <- paste(dir, "/", file, sep="")
output_path <- paste(dir, "/", "Plot_sstacks.pdf", sep="")
#print(output_path)
data_raw <- read.delim(file_path, sep=";", header = FALSE)
data_raw <- data_raw[-c(0,1), ]
data_raw$V1 <- as.character(data_raw$V1)
data_raw$V4 <- as.numeric(as.character(data_raw$V4))
data_raw$V3 <- as.numeric(as.character(data_raw$V3))
data_raw$V9 <- as.numeric(as.character(data_raw$V9))
data_raw$V13 <- as.numeric(as.character(data_raw$V13))

data_raw$V20 <- data_raw$V13 + data_raw$V9

a <- ggplot(data_raw, aes(x=data_raw$V1,y=data_raw$V4, fill=data_raw$V4)) + geom_bar(stat="identity") +
  labs(x="Individuals", y="# initial reads") +
  ggtitle("# reads per sample") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=10), , axis.text=element_text(size=12))
a+scale_fill_gradient(low="lightblue", high="darkblue")

a3 <- ggplot(data_raw, aes(x=data_raw$V1, y=data_raw$V20, fill=data_raw$V20)) +
  geom_bar(stat='identity', position='dodge')+
  labs(x="Individuals", y="# Verified haplotypes") +
  ggtitle("# Verified Haplotypes") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=10))
a3 <- a3 + scale_fill_gradient(low='lightblue',high='darkblue')

pdf(output_path, width=15, height=15)
plot_grid( a, a3, labels = c("Matching loci", "Verified haplotypes" ),label_size = 20)
dev.off()

