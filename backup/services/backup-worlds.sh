#!/bin/bash
IFS=' '
read -ra worlds <<< $(cat /var/minecraft/util/worlds.conf)
backupdir=/var/minecraft/backup/worlds/
ext=.zip

hdateformat=$(date '+%Y-%m-%d-%H-%M-%S')H$ext
ddateformat=$(date '+%Y-%m-%d')D$ext
numworlds=${#worlds[@]}

    echo "Starting multiworld backup for: ${worlds[@]}"
 
    if [ -d $backupdir ] ; then
        sleep 0
    else
        mkdir -p $backupdir
    fi
    zip $backupdir$hdateformat -r plugins
    for ((i=0;i<$numworlds;i++)); do
        zip -q $backupdir$hdateformat -r ${worlds[$i]}
        echo "Saving '${worlds[$i]}' to '$backupdir$hdateformat'."
    done
    cp $backupdir$hdateformat $backupdir$ddateformat
    echo "Updated daily backup."
    find $backupdir/ -name *H$ext -mmin +1440 -exec rm {} \;
    find $backupdir/ -name *D$ext -mtime +14 -exec rm {} \;
    echo "Removed old backups." 
 
    echo "Backup complete."

exit 0
