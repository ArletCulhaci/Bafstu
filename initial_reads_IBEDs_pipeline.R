args <- commandArgs()
file <- args[6]
dir <- args[7]
library(ggplot2)
#First install cowplot!
#library(cowplot)
file_path <- paste(dir, "/", file, sep="")
output_path <- paste(dir, "/", "Plot_raw_reads.pdf", sep="")
#print(output_path)
data_raw <- read.delim(file_path, sep=";", header = TRUE)
#data_raw <- data_raw[-c(0,1), ]
#data_raw$V1 <- as.numeric(as.character(data_raw$V1))
#data_raw$V2 <- as.numeric(as.character(data_raw$V2))
#data_raw$V3 <- as.numeric(as.character(data_raw$V3))

a <- ggplot(data_raw, aes(x=data_raw$Filename,y=data_raw$Total, fill=data_raw$Total)) + geom_bar(stat="identity") + 
  labs(x="Individuals", y="# initial reads") +
  ggtitle("# reads per sample") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=10), , axis.text=element_text(size=12))
a+scale_fill_gradient(low="lightblue", high="darkblue")
pdf(output_path, width=15, height=15)
plot(a)
dev.off()
