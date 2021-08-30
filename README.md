# MAGs_HPCpipeline
Parralelized pipeline (SLURM scheduler) for the generation of MAGs

## Requirements
This pipeline requires a number of tools to function :
- Megahit 
- MetaWrap
- QUAST
- CheckM

## Installation

### Conda environment
Create the assembly and metawrap environment
'''
conda env create -f config/assembly_conda.yml
conda env create -f config/metawrap_conda.yml 
'''

### Databases to download

#### Download the databases for CheckM

'''
cd MY_CHECKM_FOLDER
wget https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
tar -xvf *.tar.gz
rm *.gz


checkm data setRoot /path/to/your/dir/MY_CHECKM_FOLDER
'''

#### Download the database for Kraken2
Visit the following page and download the Kraken2 database of interest
https://github.com/BenLangmead/aws-indexes

#### Download the NCBI database

'''
mkdir NCBI_nt
cd  NCBI_nt
wget "ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt_v4.*.tar.gz"
for a in nt.*.tar.gz; do tar xzf $a; done

cd ..
mkdir NCBI_tax
cd NCBI_tax
wget ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz
tar -xvf taxdump.tar.gz
'''

### Install metawrap
- Clone the metawrap repository: git clone https://github.com/bxlab/metaWRAP.git

- Carefully configure the yourpath/metaWRAP/bin/config-metawrap file to it points to your desired database locations (you can modify this later). Follow the database configuration guide for details.

- Make metaWRAP executable by adding yourpath/metaWRAP/bin/ directory to to your $PATH. Either add the line PATH=yourpath/metaWRAP/bin/:$PATH to your ~/.bash_profile script, or copy over the contents of yourpath/metaWRAP/bin/ into a location already in your $PATH (such as /usr/bin/ or /miniconda2/bin/).

### Other tools

Install QUAST from the source git repository:
'''
git clone git@github.com:ablab/quast.git
'''
 
