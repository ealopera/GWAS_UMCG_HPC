# GWAS using SAIGEgds on the UMCG HPC

## Installing SAIGE
- Change cache directory of singularity (this is your home directory by default, but due to recent changes in the home directory quota this is not allowed anymore). to do this you need to type in the command line while in gearshift:  \
```export SINGULARITY_CACHEDIR="<directory of choice>" ```
- Download the executable of SAIGE, by typing teh following command. you can also check for the new version (https://github.com/weizhouUMICH/SAIGE) and change the command accordingly:  \
```singularity pull docker://wzhou88/saige:0.44```

## Build genetic relationship matrix (GRM)
Create a plink file with a select a list of SNPs by prunning your hard called genotypes (recommended LD r2<0.2, window=500kb,MAF>0.05). this will be used by SAIGE to weight for cryptic relatedness.
``` 
plink --bfile <all_chromosomes_merged_hard_call_genotypes> \
      --indep 500 50 1.04 \
      --maf 0.05 \
      --out <SNPs_for_GRM> 
 ```

## SAIGE parameters
Here is a list of the main parameters you need to run stardard GWAS. you will find these in the launch script: \
- saige_path: saige executable file path
- user: used to name the jobs in singularity and the cluster
- wkdir: working directory: temporary folders will be created here and singularuty SAIGE will take it as the current (home) folder
- jobpath: scripts called by this launcher should be located here
- featuresfile: file with phenotypes in the columns and sample IDs
- sample_col: sample IDs column name, make sure the sample IDs are the same in the phenotype and genotype files
- trait_type: "quantitative" or "binary"
- GRMfile: path to plink file (index) containing the snps and genotypes used for GRM calculation (created above)
- covar: covariate columns separated by commas
- list: For Phewas analyses indicate their names in a list, otherwise define single phenotype in the "pheno" variable
- out: path where you want the output to be located
- pheno: name of the outcome variable (it must match the column in the features file)
- testgenotypes: path to the imputed genotypes files. it should include chromosome number.
- format: format for the genotypes files (vcf or bgen)

information score (INFO>0.4) and minor allele frequency (MAF>0.01) are by defaul filtered in the step2. script.

## Running Phewas and GWAS
you should be able to run phewas by using the commands in  the launch_singularity_saige.sh. if you need a single phenotype you should run the command outside the loops and adjust the variables accordingly.




