#!/bin/bash
#SBATCH --job-name=SAIGEgds_GWAS_UGLI
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --time=00:59:00
#SBATCH --mem=10gb
#SBATCH --open-mode=append
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --array=1-23
#SBATCH --output=%x-%a.out

pwd; hostname; date
echo "working directory; hostname; date"

# Load R module containing SAIGEgds dependent packages
ml RPlus

# The chromosome shall be equal to the index of this iteration of the job-array
chr=${SLURM_ARRAY_TASK_ID}

# In case the 23rd chromosome is requested, this should be replaced by X for X-chromosome
if [[ ${chr} == "23" ]]
then
  chr="X"
fi

# Phenotype column name
pheno="<phenotype>"

# Sample ID
sample_column="UGLI_ID"

# Output file
out="<output>"

# Feature files
features="<features>"

# Genotype files
grm_snp_file="/groups/umcg-lifelines/prm03/releases/gsa_imputed/v1/GDS_files/UGLI_SNPs_for_GRM.gds"
genotype_path="/groups/umcg-lifelines/prm03/releases/gsa_imputed/v1/GDS_files/genotype.${chr}.gds"

# Output parameters defined above
echo "-------------------------"
echo "Running SAIGEgds with the following parameters:"
echo "Chromosome: ${chr}"
echo "Phenotype: ${pheno}"
echo "Output directory: ${out}"
echo "File containing phenotypic data: ${features}"
echo "Path to genotype file: ${genotype_path}"
echo "Path to genomic relationship matrix (GRM) SNPs: ${grm_snp_file}"
echo "-------------------------"

# Create the output directory
mkdir -p $out

# Run SAIGE with the with parameters defined above
Rscript /groups/umcg-lifelines/tmp01/projects/ov20_0554/analysis/saige_gwas/SAIGEgds/scripts/1.Saige_GWAS_binary_per_pheno_per_chromosome_no_filter.R \
 --outcome ${pheno} \
 --snps_for_grm ${grm_snp_file} \
 --testgenotypes ${genotype_path} \
 --out ${out} \
 --features ${features} \
 --chromosome ${chr}
