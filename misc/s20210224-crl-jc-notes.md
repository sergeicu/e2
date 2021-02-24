# On PHI
- IRB for MRI image analysis and recon - everybody who ever joined the lab - is covered under this irb (retrospective analysis of data)
- use group management to control shared acccess (via 'groupadd' etc) 
- google drives not supposed to have protected information (PHI)
- requires 


# other notes from the meeting
biogrids - add 

conaa - install your own or list pkgs to specific folder 

can buy your own space on e2 (3000 per year for 50 TB) 
50usd per year - 50 gb 


sinfo - view which 
graphical page to show load across all nodes 
http://e2-master.tch.harvard.edu/ganglia/?c=E2&m=load_one&r=hour&s=by%20name&hc=4&mc=2


alias myjobs='echo "You have" `squeue -l -u $USER | grep RUN | wc -l` "jobs running and" `squeue -l -u $USER | grep PEND | wc -l` "jobs pending"'


qq


ondemand system - virtual machine sharing system 


scancel --help 


bch-low-priority	

http://websvc4.tch.harvard.edu:8090/display/RCK/Usage+Guidelines

you can use up to 285 cpu(out of 700) 
33% of the partition's GPU capacity


SYNC ENTIRE google drive from e2 to CRL machine / local machine -
(from alex)
rclone sync /lab-share/Neuro-Cohen-e2/Public/connectomes         drive_cohenlab_Connectomes:/connectomes    --progress --copy-links --exclude '.*{/**,}' --delete-excluded --delete-during --drive-stop-on-upload-limit

--drive-stop-on-upload-limit >> stop when limit is reached


what is upload limit - 100Gb?



ssh boreas, zephyr, eurus, auster



interactive slurm 
