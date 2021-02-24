
#------------
# Option 1: copy data into Rad_Warfield_e2 (best)
#------------

# copy / move data to shared filesystem
CODEROOT=""
CODE=${CODEROOT}/""
cp $CODE /fileserver/Rad_Warfield_e2/Public/serge/
DATA=""
cp $DATA /fileserver/Rad_Warfield_e2/Public/serge/${CODE}/data/
#------------
# Option 2: clone to rc (second best)
#------------
DATA=""
rsync -e ssh -auz $DATA ch215616@e2.tch.harvard.edu/home/ch215616/data/
CODE=""
rsync -e ssh -auz $CODE ch215616@e2.tch.harvard.edu/home/ch215616/code/

#------------
# Option 3: clone to drive (not ideal)
#------------

# clone data to drive 
DATAROOT=""
DATA=""
rclone copy ${DATAROOT}${DATA} drive:/serge/ --bwlimit 8650k --tpslimit 8
CODEROOT=""
CODE=""
rclone copy ${CODEROOT}${CODE} drive:/serge/ --bwlimit 8650k --tpslimit 8

# ssh to rc 
rc 

# clone from drive to e2
DATA=""
rclone copy drive:/serge/$DATA /home/ch215616/data/--bwlimit 8650k --tpslimit 8
CODE=""
rclone copy drive:/serge/$CODE /home/ch215616/code/--bwlimit 8650k --tpslimit 8



#------------
# SSH into e2
#------------
rc 


#------------
# RUN
#------------
CODE=""
cd /lab-share/Rad_Warfield_e2/Public/serge/$CODE
sbatch run_slurm.sh
