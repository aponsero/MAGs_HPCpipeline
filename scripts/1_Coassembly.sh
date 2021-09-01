#!/bin/bash -l
#SBATCH --job-name=assembly
#SBATCH --account=project_2001503
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=02:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config/config.sh

# load environment
source $CONDA/etc/profile.d/conda.sh
conda activate assembly

# echo for log
echo "job started"; hostname; date

# Get sample ID 
export SMPLE=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`
IFS=';' read -ra my_array <<< $SMPLE

SAMPLE_ID=${my_array[0]}
PAIR1=${my_array[1]}
PAIR2=${my_array[2]}

echo $SAMPLE_ID
echo $PAIR1
echo $PAIR2

# create output directories
SAMPLE_DIR="$OUT_DIR/$SAMPLE_ID"
if [[ ! -d "$SAMPLE_DIR" ]]
then
        mkdir $SAMPLE_DIR
fi

ASS_DIR="$SAMPLE_DIR/Megahit_CoA"

QUAST_DIR="$SAMPLE_DIR/Quast_$SAMPLE_ID"
if [[ ! -d "$QUAST_DIR" ]]
then
        mkdir $QUAST_DIR
fi

# run coassembly
cd $IN_DIR
megahit -1 $PAIR1 -2 $PAIR2 -o $ASS_DIR

mv $ASS_DIR/final.contigs.fa $SAMPLE_DIR/${SAMPLE_ID}_CoA.fasta
rm -r $ASS_DIR

# run Quast
cd $GEN_DIR
python $QUAST/metaquast.py $SAMPLE_DIR/${SAMPLE_ID}_CoA.fasta -r $REF_GENOMES -o $QUAST_DIR 


# echo for log
echo "job done"; date
