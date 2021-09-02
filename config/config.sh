#!/bin/bash -l
# conda directory
CONDA="/scratch/project_2004512/tools/miniconda3"
# INPUT LIST and  DIRECTORY
IN_LIST="/scratch/project_2004512/Emilia/scripts/3_MAGs_Pipeline/config/list.txt"
IN_DIR="/scratch/project_2001503/alise/temp_files/MAGs_dataset/dataset"
# OUTPUT DIRECTORY
OUT_DIR="/scratch/project_2004512/Emilia/experiments/3_Complete_MAGs_collection"
# location install QUAST
QUAST="/scratch/project_2004512/tools/quast"
# reference genomes directory
GEN_DIR="/scratch/project_2004512/Emilia/scripts/1_Coassembly/database/reference_genomes"
# list of reference genomes to use with Quast
REF_GENOMES="Bacteroides_caccae.fa,Bacteroides_fragilis.fa,Bacteroides_thetaiotaomicron.fa,Bifidobacterium_bifidum.fa,Bifidobacterium_breve.fa,Bifidobacterium_pseudocatenulatum.fa,Collinsella_aerofaciens.fa,Erysipelatoclostridium_ramosum.fa,Escherichia_coli.fa,Faecalibacterium_prausnitzii.fa,Klebsiella_oxytoca.fa,Klebsiella_pneumoniae.fa,Parabacteroides_distasonis.fa,Phocaeicola_dorei.fa,Phocaeicola_vulgatus.fa,Roseburia_intestinalis.fa,Ruminococcus_gnavus.fa,Ruminococcus_gnavus.fa,Veillonella_parvula.fa"


