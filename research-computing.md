Most links in this tutorial require BCH VPN access. Make sure you are logged in via Pulse Secure.   
Use this page as a beginner guide. Use Research Computing wiki for advanced info ([link](http://rcwiki)). 

# Intro 

Login to e2 cluster from your CRL machine: 
- `ssh <username>@e2.tch.harvard.edu`
- [Password-less login instructions](http://websvc4.tch.harvard.edu:8090/display/RCK/Access+to+E2)

Your e2 root directory has the following structure: 
- `/home/<username>` - the directory upon which you land when connecting to e2 is deceptively named in the same way as your home directory on CRL filesystem 
- however this is a totally independent directory, which has no access to your CRL filesystem at all  
- this root directory has 50 Gb file limit  
- `/temp_work/<username>` - has 5TB file limit for _each_ user. However, _each_ file that is untouched for >30days will be automatically deleted. 
[more info](http://websvc4.tch.harvard.edu:8090/display/RCK/Usage+Guidelines)


# Using CPU/GPU resources 

#### Accessing CPU and GPU resources 
- the e2 login node (i.e. the place where you land via `ssh <username>@e2.tch.harvard.edu`) should not be used to start any compute jobs
- you must request a CPU/GPU machines via SLURM algorithm  
- SLURM algorithm is a fair share queueing system that distributes resources to users 
- in other words it performs the `ssh <machine>` command for you by considering the current demand on resources from all users 
- if no compute nodes are available it will queue your request and execute your job as soon as resources become available 
- all BCH researchers have access to e2 cluster

#### How to request CPU on e2 (interactive) 
- login to e2 via `ssh <username>@e2.tch.harvard.edu`
- run `srun -A bch -p bch-interactive --pty /bin/bash`
- is equivalent to `ssh <machine>` in SLURM 
- if resources are available, you will immediately be logged into a new machine  
- this new machine will have access to the same data as your e2 login node (e.g. `/home/<username>` and `temp_work/<username>`) 

#### How to load software on e2 
- research computing staff had pre-installed many different software packages on e2 for us 
- the list can be found [here](http://websvc4.tch.harvard.edu:8090/display/RCK/Software+Packages) 
- to load any of these software you write the following command _after_ you logged into CPU/GPU node: `load module <name>` 
- e.g. `module load matlab`, `module load anaconda`, `module load singularity`
- to request new software to be installed you must write to `research-computing@childrens.harvard.edu` 
- alternatively, if you know how to use Docker, how can deploy Docker images via `singularity` software (more info below)
- alternatively, if you use anaconda, you can also deploy preinstalled binaries via `conda install <binary>` command (more info below) 

#### Running SLURM in interactive mode vs batch mode
- SLURM's batch mode will execute scripts for you automatically
- to start SLURM in batch mode, use `sbatch` command instead of `srun` command 
- e.g. `sbatch /home/<username>/your_sample_script.sh`
- there are multiple benefits to running SLURM in batch mode:
1. you do not have to wait for resources to become available to launch your job. SLURM will queue your request and automatically start your job for you 
2. SLURM will send you emails when your job starts, stops or throws an error
3. You can queue multiple tasks in the same script, which will be executed in sequence 
4. You can run many jobs in parallel by starting multiple `sbatch` requests 

#### Running SLURM with visualization (e.g. matlab) 
- If you prefer to use GUI (e.g. for matlab) you can start SLURM with `salloc` command
- Instructions are [here](http://websvc4.tch.harvard.edu:8090/display/RCK/Visualization+job)

#### SLURM `srun` options 
- e.g. `srun -A bch -p bch-interactive --ntasks=4 --mem=2G -t 24:00:00 --pty /bin/bash` 
- `-A bch` account name (always the same) 
- `-p bch-gpu` partition name. Use `bch-compute`/`bch-largemem`/`bch-interactive` for CPU and `bch-gpu` for GPU. [More info](http://websvc4.tch.harvard.edu:8090/display/RCK/Computing+Resources) 
- `--ntasks=4` number of CPU cores required 
- `--mem=2G` amount of RAM required. If you need very large RAM, use `-p bch-largemem` option also. 
- `-t 24:00:00` time allocation. Maximum allowed is 24hours. You can specify less time (there are many benefits to it). 
- `--pty /bin/bash` start an interactive bash prompt. 

#### SLURM `sbatch` options
- You can specify options for `sbatch` in the same as was for `srun`.
- However, it is much more convenient add them to your bash (.sh) script 
- that way you only neede to run `sbatch /home/<username>/your_sample_script.sh`
- e.g. example of running MATLAB script with the same options as above: 
```
#!/bin/bash
# Sample batchscript to run a simple MATLAB job on HPC
#SBATCH --partition=bch-compute                           # partitition to be used (same as "-p bch-compute")
#SBATCH --time=24:00:00                                   # Running time (in hours-minutes-seconds) (same as "-t 00:05:00) 
#SBATCH --ntasks=4                                        # Number of CPU cores required 
#SBATCH --mem=2G                                          # Memory required in Gb 
module load matlab
matlab -nodisplay -nosplash -nodesktop -r "run('your_sample_matlab_script.m');exit;"
```
- more advanced version (with FULL options):  
```
#!/bin/bash
# Sample batchscript to run a simple MATLAB job on HPC
#SBATCH --partition=bch-compute             # partition to be used 
#SBATCH --time=00:05:00                     # Running time (in hours-minutes-seconds) 
#SBATCH --job-name=test-matlab              # Job name
#SBATCH --mail-type=BEGIN,END, FAIL         # send and email when the job begins, ends or fails
#SBATCH --mail-user=<your_email_address>    # Email address to send the job status
#SBATCH --output=output_%j.txt              # The output from the script will be written here instead of the terminal 
#SBATCH --nodes=1                           # Number of cpu nodes (i.e. how many machines you want) 
#SBATCH --ntasks=4                          # Number of cpu cores per node  (i.e. how many cores per machine) 
#SBATCH --mem=10G                           # Memory required in Gb 
module load matlab
matlab -nodisplay -nosplash -nodesktop -r "run('your_sample_matlab_script.m');exit;"
```

#### SLURM with GPUs
- you can use exactly the same principles as above for instantiating GPU, with few changes required 
- you must use `--partitiion=bch-gpu` or `-p bch-gpu` flag 
- you must specify the GPU type to be used with `--gres=gpu:Quadro_RTX:1`
- where `Quadro_RTX` refers to GPU type and `1` refers to number of GPUs (per node) required 
- (unless you want to execute on multiple GPUs) you must make sure that you execute `export CUDA_AVAILABLE_DEVICES=1` before running your deep tensorflow / pytorch script 
- the number in the CUDA_AVAILABLE_DEVICES refers to the same number as in `--gres` command 
- [optional] you can specify the number of CPU cores via `ntasks` and _CPU_ RAM via `mem` as well 
- you must run `module load anaconda3` followed by a) `source activate tf-gpu` for tensorflow access b) `source activate pytorch-gpu` for pytorch access  
- example script: 
```
#!/bin/bash 
# Sample batchscript to run a tensorflow job on HPC 
#SBATCH --partition=bch-gpu                            
#SBATCH --time=00:05:00 
#SBATCH --job-name=test-gpu 
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=<username>@tch.harvard.edu 
#SBATCH --output=output_%j.txt
#SBATCH --nodes=1 
#SBATCH --ntasks=4
#SBATCH --mem=8G      # NB this refers to CPU RAM, not GPU RAM
#SBATCH --gres=gpu:Tesla_T:1

export CUDA_VISIBLE_DEVICES=1
module load anaconda3
source activate tf-gpu
python test.py
```

#### How to list your queued/running SLURM jobs 
- `squeue -u <username>`

#### How to cancel your SLURM jobs 
- `scancel <jobid>` (get jobid from `squeue` command)  

#### FAQ on SLURM
- [more help on `srun`](http://websvc4.tch.harvard.edu:8090/display/RCK/Interactive+job)
- [more examples of `sbatch`](http://websvc4.tch.harvard.edu:8090/display/RCK/Submit+job)
- extensive list of quenstions and answers on SLURM is [here](http://websvc4.tch.harvard.edu:8090/pages/viewpage.action?pageId=82223566)
- [usage guidelines](http://websvc4.tch.harvard.edu:8090/display/RCK/Usage+Guidelines)

#### List of available GPUs  
- As of this this month there are ~29 GPUs on the e2 cluster  
- At least a dozen of them have 24Gb of RAM 
- These GPUs are of type: Tesla_K, Tesla_T, Titan_RTX, Quadro_RTX 
- There is a limit of 4 GPUs per person at any one time 
- [full list](http://websvc4.tch.harvard.edu:8090/display/RCK/Partition+Association)


#### List of available CPUs  
- [Info](http://websvc4.tch.harvard.edu:8090/display/RCK/Computing+Resources)
- Please ask Alex for more help on CPUs (I mostly just use GPUs) 

#### On deploying Docker images 
- Docker requires sudo access, which is unavailable on e2
- Use singularity instead, which can build and run docker images without sudo 
- Instructions on building singularity images are [here](http://websvc4.tch.harvard.edu:8090/pages/viewpage.action?pageId=96637887)

#### Jupyter Lab / Notebook
1. Login to e2 root node 
2. Get interactive CPU/GPU instance via `srun` command
3. Load anaconda/conda `module load anaconda3`
4. Activate environment via `source activate <environment>` (to list available `<environment>` run `conda env list`)
5. Start Jupyter `jupyter lab --ip=$(hostname -i) --port=8888 --no-browser` 
6. Note the output of the above command. e.g. `http://192.168.45.23:8888/?token=1cf2e1b601987535cf302a1b98649c2a36a4ea40fe2a5af6`
7. Open a Terminal on your CRL machine / home computer and enter: `ssh -N -f -L 8888:<host_ip>:8888 <username>@rayan`, where <host_ip> corresponds to `192.168.45.23` in the output above (6.) 
8. Open browser on your CRL machine / home computer and navigate to: `http://<host_ip>:8888`
9. The browser will request token. Enter `<token>`, where token corresponds to `1cf2e1b601987535cf302a1b98649c2a36a4ea40fe2a5af6` in the output above (6.) 
- More info [here](http://websvc4.tch.harvard.edu:8090/display/RCK/Tensorflow+Notebook)

#### Tensorboard on e2
- start tensorboard on e2 via `tensorboard --logdir <path_to_training_location>` 
- perform steps 7 and 8 as in "Jupyter Lab/Notebook" instructions above. Substitute port 8888 with port given by tensorboard (typically it is 6006). You can also try sub <host_ip> with `localhost` if no host_ip given by tensorboard. 

#### Visual Studio code (Remote Development)  
- If you use VS Code, did you know that you can DIRECTLY access files on remote server via [Remote Development pack](https://code.visualstudio.com/docs/remote/remote-overview)? 
- It is a super convenient way to work in a fully integrated IDE with DIRECT access to your files on CRL filesystem / E2 filesystem 
- If want to learn more - please ask me (Serge) - perhaps we can organize another CRL JC on it 

#### List of additional GPUs and CPUs:
- Additional GPU and CPU are available via MGH's MGHHPCCC cluster
- Instructions are [here](http://websvc4.tch.harvard.edu:8090/display/RCK/High-Performance+Computing+MGHPCC+Cluster)
  
# Data Transfer 

#### Copying your data to & from e2: 
- e2 'node' (machine) does _not_ have direct access to CRL filesystem. e.g. /fileserver/motion/, /fileserver/projects/, /fileserver/abd
- it also does _not_ have direct access to your local crl home folder /home/ch215616/ either 
- you cannot mount any custom CRL filesystems on e2 
- there are tools that you can use to copy data between the CRL filesystem (or your local computer) and e2  
- These tools are: rsync, any SFTP software, /lab-share/Rad-Warfield-e2, BCH Google Drive
- IMPORTANT: all data copied to e2 must be NON-PHI

#### Copy your data using rsync: 
- `rsync` is a linux command that allows you to *copy* files between a linux filesystem and any external file storage system
- rsync is installed by default on e2.
- It should be installed on all CRL machines. If this isn't the case for your machine, please email Sean/Simon 
- `rsync -e ssh -auz /fileserver/fastscratch/README.txt <username>@e2.tch.harvard.edu/home/<username>/` - copies file (folder) from CRL to e2 
- `rsync -e ssh -auz <full_path_to_your_home_computer_folder> <username>@e2.tch.harvard.edu/home/<username>/` - copies file (folder) from your home computer to e2 
- `rsync -e ssh -auz <username>@e2.tch.harvard.edu/home/<username>/<folder> <full_path_to_your_home_computer_folder> ` - copies file (folder) from e2 to your home computer  
- note that you must use `ssh` and `-auz` in your command 
- to speed up the copying process you can use [parallel file transfer] http://websvc4.tch.harvard.edu:8090/display/RCK/Parallel+file+transfer+with+rsync)

#### Copy your data using SFTP software:
- this method is valuable for those who prefer to use Finder/Nautilus/Explorer over Terminal to navigate the filesystem instead of Linux Terminal 
- this method can be used to transfer data between your home computer and e2, or your home computer and CRL filesystem 
- you could _in theory_ use SFTP to transfer files between e2 and CRL filesystem, as long as you install on your CRL machine 
- The example given here is based on FILEZILLA software 
- you can use any other SFTP software, e.g. [winscp](http://websvc4.tch.harvard.edu:8090/pages/viewpage.action?pageId=86805011), or [cyberduck](https://cyberduck.io/download/)
- [Install](https://filezilla-project.org/) Filezilla on your home computer 
- Open Filezilla and type the following in the top bar: `HOST: sftp://e2.tch.harvard.edu Username: <username> Password: <password> Port: 22` 
- Swap `sftp://e2.tch.harvard.edu` with `sftp://<your_crl_machine>` if you want to connect to the CRL filesystem instead 
![Filezilla-screenshot](https://github.com/sergeicu/e2/blob/main/assets/filezilla-screenshot.png?raw=true)
- [tip] use an 'arrow' next to 'Quickconnect' button to access previously logged devices  
- [tip] Click 'View/Remote Directory Tree' for tree-view of the remote machine. 
- [tip] Right click on remote file and click 'View/Edit' to view file on your computer (it will be stored in temporary folder only) 
- [tip] Right click on remote file and click 'Download' to download the file to your currently opened local folder 


#### Copy your data using /lab-share/Rad-Warfield-e2: 
- [wormhole] there is a direct link between CRL filesystem and e2 
- its location on CRL filesystem is `/fileserver/Rad-Warfield-e2/` 
- its location on e2 filesystem is `/lab-share/Rad-Warfield-e2/`
- IMPORTANT 1: you must write to 'research-computing@childrens.harvard.edu' to request `read/write/execute` permissions on /lab-share/Rad-Warfield-e2 folder on e2 cluster (you must specify that you are part of Simon's research group) 
- IMPORTANT 2: this location is ONLY accessible via the following machines on CRL: boreas, auster, io, ganymede 
- therefore you must `ssh boreas` before you will be able to see this location 
- if you want to access this location from your _own_ CRL machine, you will need to spend at least a few days in back-forth emails with research computing to set it up 

#### Copy your data using BCH Google Drive: 
- you can also copy data between e2 and your BCH Google Drive
- you can do this by using `rclone` command
- please refer to my [BCH Google Drive tutorial](https://github.com/sergeicu/e2/blob/main/bch-google-drive.md) for more info

# PHI data on e2 via /lab-share/Rad-Warfield-e2: 
- tbd with Simon during the journal club  
