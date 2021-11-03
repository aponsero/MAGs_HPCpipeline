#!/bin/bash -l
#SBATCH --job-name=mags
#SBATCH --account=project_2004512
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
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
	gunzip $READ_DIR/$i
	mv $READ_DIR/${i%%.gz} "$READ_DIR/${i%%_R1_val_1.fq.gz}_1.fastq"
done

for i in $PAIR2
do
        cp $i $READ_DIR/
	gunzip $READ_DIR/$i
        mv $READ_DIR/${i%%.gz} "$READ_DIR/${i%%_R2_val_2.fq.gz}_2.fastq"
done

# Set previous output files
ASS_FILE="$SAMPLE_DIR/${SAMPLE_ID}_CoA.fasta"

# run binning
#metawrap binning -o $SAMPLE_DIR -t 40 -a $ASS_FILE --metabat2 --maxbin2 --concoct ${READ_DIR}/*.fastq

# run bin refinement
#metawrap bin_refinement -o $SAMPLE_DIR/bins_refined -t 40 -A $SAMPLE_DIR/metabat2_bins/ -B $SAMPLE_DIR/maxbin2_bins/ -C $SAMPLE_DIR/concoct_bins/ -c 70 -x 5

# reassemble bins
#cat ${READ_DIR}/*_1.fastq >> ${READ_DIR}/${SAMPLE_ID}_cat_1.fastq
#cat ${READ_DIR}/*_2.fastq >> ${READ_DIR}/${SAMPLE_ID}_cat_2.fastq

#metawrap reassemble_bins -o /scratch/project_2004512/$SAMPLE_ID -1 ${READ_DIR}/${SAMPLE_ID}_cat_1.fastq -2 ${READ_DIR}/${SAMPLE_ID}_cat_2.fastq -t 40 -m 800 -c 70 -x 5 -b $SAMPLE_DIR/bins_refined/metawrap_70_5_bins

#mv /scratch/project_2004512/$SAMPLE_ID $SAMPLE_DIR/bins_reassembly_70.5

#rm ${READ_DIR}/${SAMPLE_ID}_cat_1.fastq
#rm ${READ_DIR}/${SAMPLE_ID}_cat_2.fastq

########################
# run abundance calculation of bins
metawrap quant_bins -b $SAMPLE_DIR/bins_refined/metawrap_70_5_bins -o $SAMPLE_DIR/bins_refined/quant_bin -a $ASS_FILE ${READ_DIR}/*

# Clean the data to keep only needed files
#rm -r $SAMPLE_DIR/bins_refined/concoct_bins
#rm -r $SAMPLE_DIR/bins_refined/maxbin2_bins
#rm -r $SAMPLE_DIR/bins_refined/metabat2_bins
#rm -r $SAMPLE_DIR/bins_refined/work_files
rm -r $SAMPLE_DIR/temp_reads
#rm -r $SAMPLE_DIR/work_files
#rm -r $SAMPLE_DIR/bins_reassembly_70.5/work_files
#rm -r $SAMPLE_DIR/bins_reassembly_70.5/original_bins
rm -r $SAMPLE_DIR/bins_refined/quant_bin/assembly_index/
#rm -r $SAMPLE_DIR/concoct_bins
#rm -r $SAMPLE_DIR/maxbin2_bins
#rm -r $SAMPLE_DIR/metabat2_bins


# echo for log
echo "job finished;"; date
