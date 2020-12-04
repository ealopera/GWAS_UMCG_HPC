# GWAS using SAIGEgds on the UMCG HPC

## Install R packages libraries

R libraries have to be installed for SAIGEgds to work. Set the preferred location to install R packeges by setting the `R_LIBS` environment variable.
This can be easily set the following file: `~/.Renviron`

The file should contain the line below, make sure to replace `<R library location>` with a location the R packages can be written to, and loaded from.
```bash
R_LIBS=<R library location>
```

Subsequently, the R packages have to be installed. Execute the commands below:
```bash
# Load the R module. RPlus contains a selection of pre-installed packages
ml RPlus

# Install packages
Rscript ./install.packages.R
```

## Provide parameters

`SAIGEgds_job-array.sh` contains parameters. These should be adapted.

### Features

`features` must be a path to a file with space separated columns.

### Pheno

`pheno` represents the target phenotype to perform associations for with genotypes. This must match a column within the `features` table.

### Covariate formula

`covariate_formula` should be a formula containing covariates. Spaces are not allowed in this argument. Covariates must be present in the `features` table

### Trait type

If the target phenotype (`pheno`) represents a binary phenotype (e.g. a disorder, having red natural hair colour), the trait type (`trait_type`) should be 'binary'. If the phenotype represents a continuous / quantitative phenotype (e.g. height, educational attainment, platelet concentration), the trait type should be 'quantitative'.
