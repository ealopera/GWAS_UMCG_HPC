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
pheno="COVID_C2_v2"

# Sample ID
sample_column="UGLI_ID"

# Output file
out="/groups/umcg-lifelines/tmp01/projects/ov20_0554/analysis/saige_gwas/week1-15b_partial_susceptibility_C2_v2/ugli/output2/"
out_path="${out}/p-values.chr.${chr}.txt"

# Feature files
features="/groups/umcg-lifelines/tmp01/projects/ov20_0554/analysis/saige_gwas/SAIGE/phenotypes/covid19-week1-15b_ugli_covid_postest_vs_population_C2_v2.dat"

# Trait type
# Should either be binary or quantitative
trait_type="binary"

# Covariate formula, e.g. "sex+age+age*sex"
# Covariates must be present in the 'features' file
covariate_formula="COVID_SEX+COVID_AGE+COVID_SEX*COVID_AGE+COVID_AGE^2"

# Genotype files
grm_snp_file="/groups/umcg-lifelines/tmp01/releases/gsa_imputed/v1/GDS_files/UGLI_SNPs_for_GRM.gds"
genotype_path="/groups/umcg-lifelines/tmp01/releases/gsa_imputed/v1/GDS_files/genotype.${chr}.gds"

# Output parameters defined above
echo "-------------------------"
echo "Running SAIGEgds with the following parameters:"
echo "Chromosome: ${chr}"
echo "Sample ID column: ${sample_column}"
echo "Phenotype: ${pheno}"
echo "Covariate formula: ${covariate_formula}"
echo "File containing phenotypic data: ${features}"
echo "Path to genotype file: ${genotype_path}"
echo "Path to genomic relationship matrix (GRM) SNPs: ${grm_snp_file}"
echo "Output path: ${out_path}"
echo "-------------------------"

# Create the output directory
mkdir -p $out

# Run SAIGE with the with parameters defined above
Rscript "./SAIGEgds_GWAS_script.R" \
 --outcome ${pheno} \
 --snps_for_grm ${grm_snp_file} \
 --testgenotypes ${genotype_path} \
 --output_path ${out_path} \
 --features ${features} \
 --trait_type ${trait_type} \
 --covariate_list ${covariate_formula} \
 --sample_id_column ${sample_column}
