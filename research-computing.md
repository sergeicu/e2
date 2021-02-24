# Intro 
Login to your e2 cluster from your CRL machine 
`ssh <username>@e2.tch.harvard.edu`
[more info](http://websvc4.tch.harvard.edu:8090/display/RCK/Access+to+E2)

Your e2 root directory has the following structure: 
- `/home/<username>` - root workdir is named as your CRL machine 
- root workdir has 50 Gb file limit 
- `/temp_work/<username>` - has 5TB file limit for _each_ user. However, _each_ file that is untouched for >30days will be automatically deleted. 
[more info](http://websvc4.tch.harvard.edu:8090/display/RCK/Usage+Guidelines)

# Using CPU/GPU resources 


#### List of available GPUs and CPUs: 
http://websvc4.tch.harvard.edu:8090/display/RCK/Partition+Association

#### List of additional GPUs and CPUs:
http://websvc4.tch.harvard.edu:8090/display/RCK/High-Performance+Computing+MGHPCC+Cluster

#### Example how to submit jobs (via SLURM)
http://websvc4.tch.harvard.edu:8090/display/RCK/Submit+job#Submitjob-Examplefiles
- large memory jobs 
- matlab jobs 
- tensorflow / gpu 

#### Example of how to submit INTERACTIVE jobs (via SLURM)
http://websvc4.tch.harvard.edu:8090/display/RCK/Interactive+job
- Compute Session 
    - Jupyter Notebook 
    - Large Memory Session
  
#### Training Tensorflow notebook:
http://websvc4.tch.harvard.edu:8090/display/RCK/Tensorflow+Notebook


#### Jupyter 

#### Full instructions 
#### http://websvc4.tch.harvard.edu:8090/display/RCK/Tensorflow+Notebook

#### Example submit jobs 
#http://websvc4.tch.harvard.edu:8090/display/RCK/Submit+job#Submitjob-Examplefiles

#### Tesla cards: --gres=gpu:Tesla_T:<N> OR --gres=gpu:Tesla_K:<N> OR --gres=gpu:Titan_RTX:<N> OR --gres=gpu:Quadro_RTX:<N>

#### WARNING: 
```#Always specify the environment variable "CUDA_VISIBLE_DEVICES" in your scripts and set it to what you set with --gres. For instance:
  #SBATCH --gres=gpu:Tesla_K:1
  #export CUDA_VISIBLE_DEVICES=1
```

#### Bash example
cd
cd tutorials/batchscript/gpu/cuda
sbatch sample-0.sh

#### Jupyter Notebook example 
cd $TEMP_WORK
srun -A bch -p bch-gpu -n 2 --mem=8GB --gres gpu:Tesla_K:1 --pty /bin/bash
module load anaconda3
source activate tf-gpu
jupyter notebook --ip=$(hostname -i) --port=8888 --no-browser

#### example from someone's command from `ps -ef | grep gpu:` while on e2 server
srun -A bch -p bch-gpu --gres=gpu:Quadro_RTX:1 -t 120:00:00 --pty /bin/bash 

    
#### Slurm
rc # login to e2
cd tutorials/batchscript/gpu/tensorflow/
sbatch sample-0.sh
squeue --user=$USER
squeue -u $USER
scancel <jobid>
    
    
#### Slurm help 
    http://websvc4.tch.harvard.edu:8090/pages/viewpage.action?pageId=82223566#FrequentlyAskedQuestions(FAQ)-HowcanIincludealistofnodesforjobsubmissionsinSLURM?
    
        
#### Where are GPUs located: 
    Tesla K -> 0-0, 0-1;  Tesla T -> 0-0, 0-1; Titan_RTX -> 1-0, 2-0, 3-0; Quadro -> 3-0, 0-0, 0-1;
    Find these via: 
    srun -A bch -p bch-gpu --gres=gpu:Quadro_RTX:1 --nodelist gpu-0-1 -t 24:00:00 --pty /bin/bash 

# Data Transfer 

#### Copying your data to & from e2: 
- e2 'node' (machine) does _not_ have direct access to CRL filesystem. e.g. /fileserver/motion/, /fileserver/projects/, /fileserver/abd
- it also does _not_ have direct access to your local crl home folder /home/ch215616/ 
- you cannot mount any given CRL filesystems on e2 
- there are a number of tools that one could use to share data between CRL (or your local computer) and e2 
- e.g. rsync, any SFTP software, /lab-share/Rad-Warfield-e2, BCH Google Drive
- IMPORTANT: all data shared to e2 must be NON-PHI

#### Copy your data using rsync: 
- `rsync` is linux command that allows *copy* of files between linux harddrive and any external file storage systems 
- rsync is installed by default on e2. I _believe_ it is also installed on CRL machines. If not, try `sudo yum install rsync` (or ask Sean to help) 
- `rsync -e ssh -auz /fileserver/fastscratch/README.txt <username>@e2.tch.harvard.edu/home/<username>/` - copies file (folder) from CRL to e2 
- `rsync -e ssh -auz <full_path_to_your_home_computer_folder> <username>@e2.tch.harvard.edu/home/<username>/` - from your home computer to e2 
- `rsync -e ssh -auz <username>@e2.tch.harvard.edu/home/<username>/<folder> <full_path_to_your_home_computer_folder> ` - // from e2 to your home computer  
- note that you must use `ssh` in your command 
[more info on FAST parallel file transfer](http://websvc4.tch.harvard.edu:8090/display/RCK/Parallel+file+transfer+with+rsync)

#### Copy your data using SFTP software:
- this method is useful for those who prefer to use Finder/Nautilus/Explorer over Terminal to navigate the filesystem instead of Linux Terminal 
- this method can be used to transfer data between your home computer and e2, or your home computer and CRL filesystem 
- you could _in theory_ use SFTP to transfer files between e2 and CRL filesystem, as long as you install on your CRL machine 
- The example given here is based on FILEZILLA software 
- you can use any other SFTP software, e.g. [winscp](http://websvc4.tch.harvard.edu:8090/pages/viewpage.action?pageId=86805011), or [cyberduck](https://cyberduck.io/download/)
- [Install](https://filezilla-project.org/) Filezilla on your home computer 
- Open Filezilla and type the following in the top bar: HOST: sftp://e2.tch.harvard.edu Username: <username> Password: <password> Port: 22 
- Swap sftp://e2.tch.harvard.edu with sftp://<your_crl_machine> if you want to connect to CRL 
- [tip] use an arror drop-down next to Quickconnect button to access previously logged devices 
- [tip] Click 'View/Remote Directory Tree' for tree-view of the remote machine. 
- [tip] Right click on remote file and click 'View/Edit' to view file on your computer (it will be stored in temporary folder only) 
- [tip] Right click on remote file and click 'Download' to download the file to your currently opened local folder 

#### Copy your data using /lab-share/Rad-Warfield-e2: 
- [wormhole] there is a direct link between CRL filesystem and e2 
- its location on CRL filesystem is `/fileserver/Rad-Warfield-e2/` 
- its location on e2 filesystem is `/lab-share/Rad-Warfield-e2/`
- IMPORTANT 1: you must write to 'research-computing@childrens.harvard.edu' to request `read/write/execute` permissions on /lab-share/Rad-Warfield-e2 folder on e2 cluster (you must specify that you are part of Simon's research group) 
- IMPORTANT2: this location is ONLY accessible via the following machines on CRL: boreas, auster, io, ganymede 
- therefore you must `ssh boreas` before you will be able to see this location 
- if you want to access this location from your _own_ CRL machine, you will need to spend at least a few days in back-forth emails with research computing to set it up 

#### Copy your data using BCH Google Drive: 
- you can also copy data between e2 and your BCH Google Drive
- you can do this by using `rclone` command
- please refer to my [BCH Google Drive tutorial](https://github.com/sergeicu/e2/blob/main/bch-google-drive.md) and [RC website](http://websvc4.tch.harvard.edu:8090/display/RCK/Google+Drive+to+E2) for more info 
