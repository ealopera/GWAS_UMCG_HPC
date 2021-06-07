###################################
### File convertion from VCF to GDS
### version 1.0
### date: 01-20-2020
### Author:EALM
###################################
##New

### load necessary packages and create functions

library(SNPRelate)
library(SAIGEgds)
library(GWASTools)
library(data.table)
library(tidyverse)
library(optparse)
#################

#opt<-list()

#opt$workdir="/UGLI_gds/genotype"
#opt$file<-"full_genotype_single.vcf"
#opt$output<-"full_genotype_single"

###test run
#Rscript vcftoGDS.R -w "/UGLI_gds/genotype" \
#                   -f "full_genotype_nn.vcf" \
#                   -o "full_genotype_nn"


#############################################
######################## arguments ##########

option_list = list(
  
  make_option(c("-w", "--workdir"), type="character", default=NULL, 
              help="working directory of both input output files", metavar="character"),
  
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="", metavar="character"),
  
  make_option(c("-o", "--output"), type="character", default=NULL, 
              help="root (fixed part) file name of the file(s) to convert", metavar="character")
  
  
) 

opt_parser  <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)
################################################################################

## turn the vcf GENOTYPE file into a seqGDS file (it has to be seq file bcause SAIGEgds does not accept snpGDS calss)
## for full genotype

#seqVCF2GDS(opt$file, paste0("genotype.",".full",".gds"), fmt.import="DS")

## for chromosome list files
working.dir<-file.path(opt$workdir)
setwd(opt$workdir)

  file.in<-file.path(working.dir,opt$file) 
  #file.out<-file.path(working.dir,)
  file.out<-paste0(opt$output,".gds")
  seqVCF2GDS(file.in,   file.out, fmt.import="DS") 

##done
  
