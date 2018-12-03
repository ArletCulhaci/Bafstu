args <- commandArgs()
file <- args[6]
dir <- args[7]
library(ggplot2)
library(cowplot)
#First install cowplot!
#library(cowplot)
file_path <- paste(dir, "/", file, sep="")
output_path <- paste(dir, "/", "Plot_ustacks.pdf", sep="")
#print(output_path)
data_raw <- read.delim(file_path, sep=";", header = FALSE)
data_raw <- data_raw[-c(0,1), ]
data_raw$V1 <- as.character(data_raw$V1)
data_raw$V2 <- as.numeric(as.character(data_raw$V2))
data_raw$V3 <- as.numeric(as.character(data_raw$V3))
data_raw$V9 <- as.numeric(as.character(data_raw$V9))
data_raw$V10 <- as.numeric(as.character(data_raw$V10))

a <- ggplot(data_raw, aes(x=data_raw$V1,y=data_raw$V2, fill=data_raw$V2)) + geom_bar(stat="identity") +
  labs(x="Individuals", y="# initial reads") +
  ggtitle("# reads per sample") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=10), , axis.text=element_text(size=12))
a+scale_fill_gradient(low="lightblue", high="darkblue")

b <- ggplot(data_raw, aes(x=data_raw$V1,y=data_raw$V9, fill=data_raw$V9)) + geom_bar(stat="identity") +
  labs(x="Individuals", y="# Stacks") +
  ggtitle("# Stacks per sample") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=10), , axis.text=element_text(size=12))
b+scale_fill_gradient(low="lightblue", high="darkblue")

c <- ggplot(data_raw, aes(x=data_raw$V1,y=data_raw$V10, fill=data_raw$V10)) + geom_bar(stat="identity") +
  labs(x="Individuals", y=" mean depth") +
  ggtitle("# Depth per sample") +
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size=10), , axis.text=element_text(size=12))
c+scale_fill_gradient(low="lightblue", high="darkblue")

pdf(output_path, width=15, height=15)
plot_grid( a, b, c, labels = c("Reads", "Stacks", "Depth"),label_size = 20)
dev.off()
