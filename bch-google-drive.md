Quick intro to BCH Google Drive.   

#### Basics
- Login - http://drive.bchresearch.org
- [Install](https://www.google.com/intl/en_ca/drive/download/
) Google Drive on your laptop
- IMPORTANT: BCH Google Drive is for NON-PHI data only 
- PHI data exception - see [here](#PHI-data)

#### Intro to rclone 
- To copy files between Google Drive and your CRL machine (or home computer) we use `rclone` 
- type `rclone` in your Terminal to check if it already installed 
- [install](https://rclone.org/downloads/) rclone on your CRL machine / home computer 
- to install rclone on your CRL machine you may also ask Sean for help. 

#### Configure rclone 
- In order to copy files between BCH Google Drive and a machine you must first configure it 
- [Full instructions are here](http://websvc4.tch.harvard.edu:8090/display/RCK/Google+Drive+to+E2)
- IMPORTANT: you must do this configuration individually on _EACH_ machine that you plan to use with rclone (e.g. your crl machine, your home computer, AND e2 cluster) 


#### Copy files between Google Drive and your machine 
- let's assume that you called your drive `mydrive` while setting up `rclone config` 
- copy files from your machine to Google Drive - `rclone copy <full_path_to_folder_or_file> mydrive:/ --bwlimit 8650k --tpslimit 8` 
- the above command will copy files into the root directory of your Google Drive. Swap `/` with `/<folder_name>` to copy to specific folder inside Google Drive
- copy files from Google Drive to your machine - `rclone copy mydrive:/<folder_to_copy>/ <full_path_on_your_machine> --bwlimit 8650k --tpslimit 8`
- note that research computing recommends using `--bwlimit 8650k --tpslimit 8` for all copy commands 

#### Other useful rclone commands 
- list all files in the root Google Drive directory - `rclone ls mydrive:` 
- // all folders in specific directory - `rclone lsd mydrive:/<specific_folder>/` 
- list files and folders in a tree like fashion - `rclone tree mydrive:/`
- More info [here](https://rclone.org/docs/) 

#### Mount Google Drive to your CRL filesystem 
- it is possible to make your Google Drive files available on your CRL filesystem 
- however, the refresh rate of this can be slow (use with caution)
- `rclone mount --daemon mydrive:/ <full_path_to_folder>/<name_of_NEW_folder_to_be_created_for_google_drive_files>` 
- if something went wrong you can unmount this via `fusermount -u <full_path_to_folder>/<name_of_NEW_folder_to_be_created_for_google_drive_files>`

#### Mount Google Drive to your home computer 
- you can view folders and files of your Google Drive on your local computer by using Google Drive app ([install instructions](https://www.google.com/intl/en_ca/drive/download/))
- this may be useful for those who want to use files locally on their home computer (e.g. to view nifti files with ITKsnap) 
- please make sure that you are NOT connected to Pulse Secure when setting up your Google Drive app on your home computer 
- note that Google Drive app creates _symlinks_ on your home computer, it does not actually take up space on your computer  
- any files that you open with Google Drive app are downloaded into a temporary space (and are then discarded after you close them / reboot computer) 

#### PHI data
- tbd with Simon and Alex
