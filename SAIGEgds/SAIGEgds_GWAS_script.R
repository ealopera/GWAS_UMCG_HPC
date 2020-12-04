###################################
### SAIGEgds gwas per chromosome
### version 2.0
### date: 04-12-2020
### Authors:EALM, AJC, CAW
###################################

library(SNPRelate)
library(SAIGEgds)
library(GWASTools)
library(data.table)
library(optparse)

#############################################
######################## arguments ##########

option_list = list(
  
  make_option(c("-m", "--outcome"), type="character", default=NULL, 
              help="List of features or outcomes to be evaluated", metavar="character"),
  
  make_option(c("-s", "--snps_for_grm"), type="character", default=NULL, 
              help="", metavar="character"),
  
  make_option(c("-t", "--testgenotypes"), type="character", default=NULL, 
              help="", metavar="character"),
  
  make_option(c("-o", "--output_path"), type="character", default=NULL, 
              help="", metavar="character"),
  
  make_option(c("-f", "--features"), type="character", default=NULL, 
              help="", metavar="character"),
  
  make_option(c("-T", "--trait_type"), type = "character", default="binary",
              help="", metavar="character"),

  make_option(c("-F", "--covariate_list"), type="character", default=NULL,
              help="", metavar="character"),

  make_option(c("-S", "--sample_id_column"), type="character", default=NULL,
              help="", metavar="character")
)

# Parse arguments 
parser  <- OptionParser(option_list=option_list)
opt <- parse_args(parser)

# Check if the required options are provided
if (is.na(opt$outcome)) {
  stop("'--outcome' must be provided. See script usage (--help)")
}
if (is.na(opt$snps_for_grm)) {
  stop("'--snps_for_grm' must be provided. See script usage (--help)")
}
if (is.na(opt$testgenotypes)) {
  stop("'--testgenotypes' must be provided. See script usage (--help)")
}
if (is.na(opt$output_path)) {
  stop("'--output_path' must be provided. See script usage (--help)")
}
if (is.na(opt$features)) {
  stop("'--features' must be provided. See script usage (--help)")
}
if (is.na(opt$covariate_list)) {
  stop("'--covariate_list' directory must be provided. See script usage (--help)")
}
if (is.na(opt$sample_id_column)) {
  stop("'--sample_id_column' directory must be provided. See script usage (--help)")
}
if (!opt$trait_type %in% c("binary", "quantitative")) {
  stop(paste0("Trait type ('--trait_type') should either be 'binary' or 'quantitative', not '", parser$trait_type, "'. See script usage (--help)"))
}

#############################################
########## main #############################

###  1. load list of phenotypes
# sample IDs in the phenotype file has to be the same as in genetic file (samples to use in the association analysis) 
phenofeatures <- fread(opt$features,data.table = F,header=T)

### 2. fit null model
    pheno <- opt$outcome
    col.filter <- which(colnames(phenofeatures)==pheno)
    select.rows <- which(!is.na(phenofeatures[,col.filter]))
    model <- paste0(opt$outcome," ~ ", opt$covariate_list )
    glmm2 <- seqFitNullGLMM_SPA( as.formula(model) , 
                                 data=phenofeatures[select.rows,], 
                                 opt$snps_for_grm, 
                                 trait.type=opt$trait_type, 
                                 sample.col=opt$sample_id_column) 

### 3. calculate association
    genotype.file <- file.path(opt$testgenotypes)
    assoc <- seqAssocGLMM_SPA(genotype.file, glmm2, maf=0)

### 4. save p-values
    assoc.out <- opt$output_path
    write.table(assoc,assoc.out,quote=F,row.names = F,col.names = T,sep='\t')
    
######
