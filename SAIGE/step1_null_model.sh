#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=3gb

echo hostname
echo "wkdir:" $1
echo "phenotype=" $2
echo "pheno_file=" $3
echo "GRMfile=" $4
echo "out=" $5
echo "threads=" $6
echo "covar" $7
echo "removezero=" ${8}
echo "singularityname=" ${9}
echo "sample_col=" ${10}
echo "trait_type=" ${11}
echo "saige_path=" ${12}


##################################### step 1 ###################################################
  mkdir -p ${1}/${5}
  if [[ ${8} == "1" ]]; then
      ### get the column nu2er for the specific trait
      n_2=$( awk  -v col=${2} 'NR==1{for (i=1; i<=NF; i++) if ($i==col) {print i;exit}}' ${1}/${3}  )
      ### create no_) file for the 3
      awk  -F'\t'  '$n!=0 '  n=$n_2  ${1}/$3> ${1}/${5}/feat.temp
    else
      cat ${1}/{3} > ${1}/${5}/feat.temp
  fi
  
  nsize=$( wc -l ${1}/${5}/feat.temp )
  echo "number of non-NA samples =" ${nsize}
  
  singularity instance start -B  ${1}:/tmp ${12} ${9}
  ###launch step 1 (null model)
  #For Quantitative traits, if not normally distributed, inverse normalization needs to be specified to be TRUE --invNormalize=TRUE
  
  if [[ ${11} != "binary"  ]]; then
   
  singularity exec instance://${9}  step1_fitNULLGLMM.R \
          --plinkFile=/tmp/${4} \
          --phenoFile=/tmp/${5}/feat.temp \
          --phenoCol=${2} \
          --covarColList=${7} \
          --sampleIDColinphenoFile=${10} \
          --traitType=${11}  \
          --invNormalize=TRUE     \
          --outputPrefix=/tmp/${5}/model \
          --IsOverwriteVarianceRatioFile=TRUE \
          --LOCO=FALSE    \
          --nThreads=${6} \
          --tauInit=1,0
else
	
  singularity exec instance://${9}  step1_fitNULLGLMM.R \
          --plinkFile=/tmp/${4} \
          --phenoFile=/tmp/${5}/feat.temp \
          --phenoCol=${2} \
          --covarColList=${7} \
          --sampleIDColinphenoFile=${10} \
          --traitType=${11}  \
          --outputPrefix=/tmp/${5}/model \
          --IsOverwriteVarianceRatioFile=TRUE \
          --LOCO=FALSE    \
          --nThreads=${6} \
          --tauInit=1,0
fi
  
rm ${1}/${5}/feat.temp
singularity instance stop ${9} 



