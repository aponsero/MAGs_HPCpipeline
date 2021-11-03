#!/bin/bash -l
#SBATCH --job-name=Classif
#SBATCH --account=project_2004512
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=longrun
#SBATCH --time=150:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config/config.sh

# load environment
source $CONDA/etc/profile.d/conda.sh
conda activate metawrap-env

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

# set output directories
SAMPLE_DIR="$OUT_DIR/$SAMPLE_ID"

# run bin classification
metawrap classify_bins -b $SAMPLE_DIR/bins_reassembly_70.5/reassembled_bins -o $SAMPLE_DIR/bins_reassembly_70.5/Classification -t 40

# echo for log
echo "job finished;"; date
