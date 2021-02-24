Login to your e2 cluster from your CRL machine 
`ssh <username>@e2.tch.harvard.edu`
[more info](http://websvc4.tch.harvard.edu:8090/display/RCK/Access+to+E2)

Your e2 root directory has the following structure: 
- `/home/<username>` - root workdir is named as your CRL machine 
- root workdir has 50 Gb file limit 
- `/temp_work/<username>` - has 5TB file limit for _each_ user. However, _each_ file that is untouched for >30days will be automatically deleted. 
[more info](http://websvc4.tch.harvard.edu:8090/display/RCK/Usage+Guidelines)

Copying your data to & from e2: 
- e2 'node' (machine) does _not_ have direct access to CRL filesystem. e.g. /fileserver/motion/, /fileserver/projects/, /fileserver/abd
- it also does _not_ have direct access to your local crl home folder /home/ch215616/ 
- you cannot mount any given CRL filesystems on e2 
- there are a number of tools that one could use to share data between CRL (or your local computer) and e2 
- e.g. rsync, any SFTP software, /lab-share/Rad-Warfield-e2, BCH Google Drive
- IMPORTANT: all data shared to e2 must be NON-PHI

Copy your data using rsync: 
- `rsync` is linux command that allows *copy* of files between linux harddrive and any external file storage systems 
- rsync is installed by default on e2. I _believe_ it is also installed on CRL machines. If not, try `sudo yum install rsync` (or ask Sean to help) 
- `rsync -e ssh -auz /fileserver/fastscratch/README.txt <username>@e2.tch.harvard.edu/home/<username>/` - copies file (folder) from CRL to e2 
- `rsync -e ssh -auz <full_path_to_your_home_computer_folder> <username>@e2.tch.harvard.edu/home/<username>/`


# List of available GPUs and CPUs: 
http://websvc4.tch.harvard.edu:8090/display/RCK/Partition+Association

# List of additional GPUs and CPUs:
http://websvc4.tch.harvard.edu:8090/display/RCK/High-Performance+Computing+MGHPCC+Cluster

# Example how to submit jobs (via SLURM)
http://websvc4.tch.harvard.edu:8090/display/RCK/Submit+job#Submitjob-Examplefiles
- large memory jobs 
- matlab jobs 
- tensorflow / gpu 

# Example of how to submit INTERACTIVE jobs (via SLURM)
http://websvc4.tch.harvard.edu:8090/display/RCK/Interactive+job
- Compute Session 
    - Jupyter Notebook 
    - Large Memory Session
  
# Training Tensorflow notebook:
http://websvc4.tch.harvard.edu:8090/display/RCK/Tensorflow+Notebook


############
# RSync 
############

# transfer from CRL filesystem to e2 
rsync -e ssh -auz $crlfolder/EXAMPLE_FILE ch215616@e2.tch.harvard.edu/home/ch215616/

# transfer from e2 to crl 
rsync -e ssh -auz ch215616@e2.tch.harvard.edu/home/ch215616/EXAMPLE_FILE $crlfolder

# Parallel file transfer 
ls | parallel --will-cite -j 4 rsync -ravhzP -e ssh {} ahayati@OSXLAP05101:/Users/ahayati/destination_test
http://websvc4.tch.harvard.edu:8090/display/RCK/Parallel+file+transfer+with+rsync

############
# RClone
############

# transfer from e2 to gdrive 
rclone copy  MyDrive: --bwlimit 8650k --tpslimit 8
# list files 
rclone ls main:
# copy from e2 to drive
rclone copy /home/ch215616/EXAMPLE main:/serge/

# More info 
http://websvc4.tch.harvard.edu:8090/display/RCK/Data+transfer


############
# Jupyter 
############

# Full instructions 
# http://websvc4.tch.harvard.edu:8090/display/RCK/Tensorflow+Notebook

# Example submit jobs 
#http://websvc4.tch.harvard.edu:8090/display/RCK/Submit+job#Submitjob-Examplefiles

# Tesla cards: --gres=gpu:Tesla_T:<N> OR --gres=gpu:Tesla_K:<N> OR --gres=gpu:Titan_RTX:<N> OR --gres=gpu:Quadro_RTX:<N>

# WARNING: 
#Always specify the environment variable "CUDA_VISIBLE_DEVICES" in your scripts and set it to what you set with --gres. For instance:
  #SBATCH --gres=gpu:Tesla_K:1
  #export CUDA_VISIBLE_DEVICES=1


# Bash example
cd
cd tutorials/batchscript/gpu/cuda
sbatch sample-0.sh

# Jupyter Notebook example 
cd $TEMP_WORK
srun -A bch -p bch-gpu -n 2 --mem=8GB --gres gpu:Tesla_K:1 --pty /bin/bash
module load anaconda3
source activate tf-gpu
jupyter notebook --ip=$(hostname -i) --port=8888 --no-browser

# example from someone's command from `ps -ef | grep gpu:` while on e2 server
srun -A bch -p bch-gpu --gres=gpu:Quadro_RTX:1 -t 120:00:00 --pty /bin/bash 

    
############
# Slurm
############
rc # login to e2
cd tutorials/batchscript/gpu/tensorflow/
sbatch sample-0.sh
squeue --user=$USER
squeue -u $USER
scancel <jobid>
    
    
# Slurm help 
    http://websvc4.tch.harvard.edu:8090/pages/viewpage.action?pageId=82223566#FrequentlyAskedQuestions(FAQ)-HowcanIincludealistofnodesforjobsubmissionsinSLURM?
    
    
# Storage 
    Users have 5TB temporary disk space in /temp_work ($TEMP_WORK) and should use that for temporary large data storage. To learn more visit User Policies#DiskQuota 
    cd $TEMP_WORK 
    
    
    cd /lab-share/Rad-Warfield-e2/Public
    # also accessible via boreas,auster,zephyr,eurus on /fileserver/
    
    
# Where are GPUs located: 
    Tesla K -> 0-0, 0-1;  Tesla T -> 0-0, 0-1; Titan_RTX -> 1-0, 2-0, 3-0; Quadro -> 3-0, 0-0, 0-1;
    Find these via: 
    srun -A bch -p bch-gpu --gres=gpu:Quadro_RTX:1 --nodelist gpu-0-1 -t 24:00:00 --pty /bin/bash 
