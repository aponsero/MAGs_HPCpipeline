#!/bin/bash -l
#SBATCH --job-name=metaQuast
#SBATCH --account=project_2004512
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=72:00:00
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

# create output directories
SAMPLE_DIR="$OUT_DIR/$SAMPLE_ID"
READ_DIR="$OUT_DIR/$SAMPLE_ID/temp_reads"
mkdir $READ_DIR


# copy the needed read files for mapping
cd $IN_DIR
IFS=',' 

for i in $PAIR1 
do
	cp $i $READ_DIR/
done

for i in $PAIR2
do
        cp $i $READ_DIR/
done

# Set previous output files
ASS_FILE="$SAMPLE_DIR/${SAMPLE_ID}_CoA.fasta"

# run binning
#metawrap binning -o $OUT_DIR -t 40 -a $ASS_FILE --metabat2 --maxbin2 --concoct ${READ_DIR}*

# run bin refinement
#metawrap bin_refinement -o $OUT_DIR/bins_refined -t 40 -A $OUT_DIR/metabat2_bins/ -B $OUT_DIR/maxbin2_bins/ -C $OUT_DIR/concoct_bins/ -c 70 -x 5

# run abundance calculation of bins
#metawrap quant_bins -b $OUT_DIR/bins_refined/metawrap_70_5_bins -o $OUT_DIR/bins_refined/quant_bin -a $ASS_FILE ${READ_DIR}*

# reassemble bins
#cat ${READ_DIR}*_1.fastq > ${READ_DIR}cat_1.fastq
#cat ${READ_DIR}*_2.fastq > ${READ_DIR}cat_2.fastq
#metawrap reassemble_bins -o /scratch/project_2004512/reas_bin -1 ${READ_DIR}cat_1.fastq -2 ${READ_DIR}cat_2.fastq -t 40 -m 800 -c 70 -x 5 -b $OUT_DIR/bins_refined/metawrap_70_5_bins

#mv /scratch/project_2004512/reas_bin $OUT_DIR/bins_reassembly_70.5

# Clean the data to keep only needed files

# echo for log
echo "job finished;"; date
