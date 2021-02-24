#!/bin/bash
# Sample batchscript to run a GPU-Cuda job on multi gpus
#SBATCH --partition=bch-gpu             # queue to be used
#SBATCH --time=120:00:00                # Running time (in hours-minutes-seconds)
#SBATCH --mail-type=BEGIN,END,FAIL      # send and email when the job begins, ends or fails
#SBATCH --mail-user=serge.vasylechko@tch.harvard.edu      # Email address to send the job status
#SBATCH --output=output_%j.txt          # Name of the output file
#SBATCH --nodes=1                       # Number of gpu nodes
#SBATCH --ntasks=2                      # Number of cpu cores required
#SBATCH --gres=gpu:Tesla_K:2            # Number of gpu devices on one gpu node
#SBATCH --mem=8GB                       # Amount of RAM memory needed
#SBATCH --job-name=test-gpu             # Job name
 
# available partitions: fnndsc-gpu, bch-gpu, + mghhpc (separate cluster)
# available gpus: Tesla_T:    Tesla_K:  Titan_RTX:   Quadro_RTX: 


export CUDA_VISIBLE_DEVICES=2           # Ensure 2 GPUs are active on the job (should match --gres entry)

module load anaconda3
source activate tf-gpu
#jupyter notebook --ip=$(hostname -i) --port=8888 --no-browser
python test.py
