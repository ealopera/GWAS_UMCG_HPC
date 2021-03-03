##### Launcher for SAIGE in gearshift cluster ######
## version
## date 03-03-2021
## authors: ELO, RW
###################
## New
######

## variables
## please read carefully the comments as not all variables are defined in the first segment.
# phenotype name is defined in lines 37 and 43
# genotypes filepath is defined in lines 75-77
# output folder is defined in line 45
# *** These objects are read by SAIGE. Therefore DO NOT indicate full path, but rahter the path from working directory.
 
# user: used to name the jobs in singularity and the cluster
user="EALM"
# working directory: temporary folders will be created here and singularuty SAIGE will take it as the current (home) folder
wkdir="/groups/umcg-lifelines/tmp01/projects/dag3_fecal_mgs/umcg-elopera/" 
# job path: scripts called by this launcher should be located here
jobpath="/groups/umcg-lifelines/tmp01/projects/dag3_fecal_mgs/umcg-elopera/scripts/4.SAIGE_mb_usage/singularity_gearshift"
# features file: file with phenotypes in the columns and sample IDs. ***
featuresfile="features_and_phenotypes/DAG3_gen_BMI_merged_log_v3.txt"
# sample IDs column name, make sure the sample IDs are the same in the phenotype and genotype files
sample_col="ID"
# trait type: "quantitative" or "binary"
trait_type="quantitative"
# Genetic relationship matrix (GRM): path to plink file (index) containing the snps and genotypes used for GRM calculation ***
GRMfile="genotypes/SNPsforGRM"
# covariate columns
covar="age,gender"
# nodes used. (recomended 5)
threads=5
# This command removes zero (0) values in the phenotype column reducing sample size. "1" to remove zero values, "0" to include zero values in the gwas calculation
Removezero=1
# For Phewas analyses indicate their names in a list, otherwise define sigle phenotype (line  43) and use step 1 oustide of the loop
list="${wkdir}/features_and_phenotypes/pwys_for_bgen.list"

## step 1 launcher
cat $list | while read line 
do

  pheno=${line}
  log="${wkdir}/logs/singularity/${pheno}_logs/"
  out="output/pwys_bgen/${pheno}_gwas" # ***
  mkdir -p ${log}
  
  if [ ! -e ${wkdir}/${out}/model.rda  ]; then
    singularityName="saige_${user}_step1_${pheno}"
    
    jid1=$( sbatch -J "saige.1.${pheno}" \
           -o "${log}/step1.out" \
           -e "${log}/step1.err" \
           --qos="priority" \
           --time 1:00:00 \
           -v ${jobpath}/step1_null_model.sh \
           ${wkdir} \
           ${pheno} \
           ${featuresfile} \
           ${GRMfile} \
           ${out} \
           ${threads} \
           ${covar} \
           ${Removezero} \
           ${singularityName} \
		   ${sample_col} \
           ${trait_type} )
			   
  fi
  
 jid2=$( echo "${jid1}"|cut -d" " -f4 ) ## create variable to time step 2 after step1 is finished

 ### Step 2 launcher
  
  for chr in {1..22} "X" ## change if needed, run outdside of loop for single chromosomes
    do
# genotypes files: allowed formats are bgen and vcf. this has to be specified. make sure you include index files with the same name [filename.bgen].bgi or [filename.vcf].csi ***
      testgenotypes="bgen/${chr}.UGLI.imputed.qc.bgen"
	  format="bgen" # or "vcf"
	  
      singularityName="saige_${user}_${chr}_${pheno}"
       if [ !  -z ${jid2} ]; then
        
           sbatch -J "${chr}.saige.${pheno}" \
           --dependency=afterany:$jid2 \
           -o "${log}/${chr}.out" \
           -e "${log}/${chr}.err" \
           --cpus-per-task $threads \
           --time 5:00:00 \
           -v ${jobpath}/4.step2_assoc_only.sh \
           ${wkdir} \
           ${testgenotypes} \
           ${out} \
           ${singularityName} \
           ${chr} \
		   ${format}
		   
       else
          sbatch -J "${chr}.saige.${pheno}" \
                 -o "${log}/${chr}.out" \
                 -e "${log}/${chr}.err" \
                 --cpus-per-task $threads \
                 --time 5:00:00 \
                 -v ${jobpath}/step2_assoc_only.sh \
                 ${wkdir} \
                 ${testgenotypes} \
                 ${out} \
                 ${singularityName} \
                 ${chr} \
			     ${format}
          
        fi
              sleep 0.5  
        
  done
  


sleep 20
done

#### done ####

  
