
args <- commandArgs()
file <- args[6]
dir <- args[7]
library(VariantAnnotation)
library(snpStats)
library(GenomeInfoDb)
file_path <- paste(dir, "/", file, sep="")
output_path <- paste(dir, "/", "SNP_matrix.csv", sep="")
#print(output_path)

vcf <- readVcf(file_path)

matr <- genotypeToSnpMatrix(vcf, uncertain=FALSE)

t <- t(as(matr$genotype, "character"))

write.table(t, output_path, sep="\t")
