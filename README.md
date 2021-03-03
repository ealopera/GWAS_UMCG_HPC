# GWAS_UMCG_HPC

Created by: Robert Warmerdam, Esteban Lopera
Created on: 03-03-2021
Contact information: e.a.lopera.maya@umcg.nl, robert_warmerdam@hotmail.com 

### DESCRIPTION
Here you will find instructions and scripts to calculate GWAS in the HPC-gearshift using SAIGE

### BASIC INPUT
Genotype files (VCF, BGEN or GDS)
Phenotype(s) files.
list of selected SNPs for GRM  (GDS or plink format)
list of covariates (or model)

### INSTRUCTIONS
If you are going for a quick analysis we recomend to use the GDS version of SAIGE. it uses the genotype (GT) field of the files and each chromosome might takes up to 20 min for 40k samples. you will need all your files to be in GDS format. Otherwise, if you need a more precise anaylsis use nromal SAIGE and prepare vcf of bgen files with their respective index files.
Detailed instructions are found in the respective folders.
