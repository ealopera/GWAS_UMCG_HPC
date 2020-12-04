# GWAS using SAIGEgds on the UMCG HPC

## Install R packages libraries

R packages have to be installed for SAIGEgds to work. Set the preferred location to install R packages by setting the `R_LIBS` environment variable.
This can be easily set inside the following file: `~/.Renviron`

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

## SAIGEgds parameters

A bash script has been prepared to perform a GWAS using SAIGEgds. This has been setup to run the GWAS using the UGLI dataset. this script `SAIGEgds_UGLI_job-array.sh` contains parameters for SAIGEgds. These should be adapted.

### Features

`features` must be a path to a file with space separated columns.

### Pheno

`pheno` represents the target phenotype to perform associations for with genotypes. This must match a column within the `features` table.

### Covariate formula

`covariate_formula` should be a formula containing covariates. Spaces are not allowed in this argument. Covariates must be present in the `features` table

### Trait type

If the target phenotype (`pheno`) represents a binary phenotype (e.g. a disorder, having red natural hair colour), the trait type (`trait_type`) should be 'binary'. If the phenotype represents a continuous / quantitative phenotype (e.g. height, educational attainment, platelet concentration), the trait type should be 'quantitative'.

### Output path

The output path to write summary statistics to has to set using `out`.

## Run GWAS

### SLURM parameters

The bash script is setup to run the GWAS in parallel. The job name argument (`--job-name`) can be adapted, before starting the SLURM job, to include details on the specific GWAS (used phenotype for example). Currently, the script has been setup to perform the GWAS on chromosomes 1-22, and the X (23rd) chromosome. The array argument (`--array=1-23`) can be adapted to only run the GWAS on a specific chromosome. This can be useful if an error ocurred for a specific chromosome for instance. The log files are written to `%x-%a.out`, wherin `%x` represents the job name and `%a` represents the array index / chromosome.

See [here](https://slurm.schedmd.com/) for detailed SLURM documentation.

### Job submission

The GWAS can be started using the following command: 
```bash
sbatch SAIGEgds_UGLI_job-array.sh
```
