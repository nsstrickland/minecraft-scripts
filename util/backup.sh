#!/bin/bash

PREAMBLE="[Backup Script]"
SERVERPATH="/var/minecraft/server/$1"
LOGDIR="$SERVERPATH/logs/"
WORLDPATH="/var/minecraft/universe/$1/"
BACKUPDIR="/var/minecraft/backup/server/$1"
FN="backup_$1_$(date '+%m-%d-%Y-%H-%M-%S')"
LOGS="$BACKUPDIR/$FN-logs.tar.gz"
BACKUP="$BACKUPDIR/$FN.tar.gz"
# [$(date +%H:%M:%S)] 
#tar -zcvf $BACKUPPATH/backup/$SCREENNAME.$(date +%m%d%y%H).tar.gz $SERVERPATH --exclude=/minecraft/creative/plugins/dynmap/web

if [ ! -d $BACKUPDIR ]; then
	echo "[$(date +%H:%M:%S)] $PREAMBLE '$BACKUPDIR' did not exist; making it."
	mkdir -p $BACKUPDIR
fi


## Worlds ##
echo "[$(date +%H:%M:%S)] $PREAMBLE Backing up worlds for '$1' to '$BACKUP'"
tar -zcvf $BACKUP $WORLDPATH
sleep 2
if [ ! -f $BACKUP ]; then
	echo "[$(date +%H:%M:%S)] $PREAMBLE ERROR 1: Error compressing worlds."
	exit 1
else
	echo "[$(date +%H:%M:%S)] $PREAMBLE Worlds backed up successfully."
fi
sleep 2
HASH=$(md5sum $BACKUP)
echo -e "[$(date +%H:%M:%S)] $PREAMBLE Hash of $BACKUP\n$HASH"
echo $HASH >> "$BACKUPDIR/$FN.md5" && echo "[$(date +%H:%M:%S)] $PREAMBLE World file hash written to '$BACKUPDIR/$FN.md5'."

## Logs ##
echo "[$(date +%H:%M:%S)] $PREAMBLE Backing up logs for '$1' to '$LOGS'"
tar -zcvf $LOGS $LOGDIR*
if [ ! -f $LOGS ]; then
	echo "[$(date +%H:%M:%S)] $PREAMBLE ERROR 2: Error compressing logs."
	exit 2
else
	echo "[$(date +%H:%M:%S)] $PREAMBLE Logs backed up successfully."
fi
HASH=$(md5sum $LOGS)
echo -e "[$(date +%H:%M:%S)] $PREAMBLE Hash of $LOGS\n$HASH"
echo $HASH >> "$BACKUPDIR/$FN-logs.md5" && echo "[$(date +%H:%M:%S)] $PREAMBLE Logfile hash written to '$BACKUPDIR/$FN-logs.md5'."

echo -e "[$(date +%H:%M:%S)] $PREAMBLE Backup completed successfully.\nFile sizes:\n$BACKUP: ($(du -sh "$BACKUP" | cut -f1))\n$LOGS:($(du -sh "$LOGS" | cut -f1))"

## Remove Old Backups ##
echo "[$(date +%H:%M:%S)] $PREAMBLE Removing backups older than 30 days:"
find "$BACKUPDIR/" -name "*.tar.gz" -type f -mtime +30 -print -delete

exit 0
