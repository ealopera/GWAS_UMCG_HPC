#!/bin/bash
#SBATCH --nodes=1
#SBATCH --mem=2gb

echo hostname
echo "wkdir:" $1
echo  "testgenotypes=" $2
echo "out=" $3
echo "singularityname=" ${4}
echo "chromosome:" ${5}
echo "format:" ${6}
echo "saige_path:" ${7}

##################################### step 2 ###################################################

singularity instance start -B  ${1}:/tmp ${7} ${4} 



#####second step
if [[ ${6} != "vcf"  ]]; then
   
  singularity exec instance://${4}  step2_SPAtests.R \
    --bgenFile=/tmp/${2} \
    --bgenFileIndex=/tmp/${2}.bgi \
    --sampleFile=/tmp/${2}.sample \
    --minMAF=0.01 \
    --minInfo=0.4 \
    --chrom=${5} \
    --GMMATmodelFile=/tmp/${3}/model.rda \
    --varianceRatioFile=/tmp/${3}/model.varianceRatio.txt \
    --SAIGEOutputFile=/tmp/${3}/p-values.chr.${5} \
    --IsOutputAFinCaseCtrl=FALSE \
    --LOCO=FALSE \
    --numLinesOutput=2 
  else

  singularity exec instance://${4}  step2_SPAtests.R \
    --vcfFile=/tmp/${2} \
    --vcfFileIndex=/tmp/${2}.csi \
    --vcfField=DS \
    --minMAF=0.01 \
    --minInfo=0.4 \
    --chrom=${5} \
    --GMMATmodelFile=/tmp/${3}/model.rda \
    --varianceRatioFile=/tmp/${3}/model.varianceRatio.txt \
    --SAIGEOutputFile=/tmp/${3}/p-values.chr.${5} \
    --IsOutputAFinCaseCtrl=FALSE \
    --LOCO=FALSE \
    --numLinesOutput=2 
fi


singularity instance stop ${4} 



