#!/bin/bash
PREAMBLE="[RCON Password PreExec Script]"
NEWPASS=$(date +%s | sha256sum | base64 | head -c 32)
FILE="/var/minecraft/server/$1/server.properties"
OLDSUM=$(md5sum $FILE | cut -d ' ' -f 1)
echo "[$(date +%H:%M:%S)] $PREAMBLE Generating new RCON password in '$FILE'"
sed -i.bak "s/rcon.password=.*/rcon.password=$NEWPASS/" $FILE
NEWSUM=$(md5sum "$FILE" | cut -d ' ' -f 1)

if [ $OLDSUM == $NEWSUM ]; then
	echo "[$(date +%H:%M:%S)] $PREAMBLE Something went wrong."
	exit 1
else
	echo "[$(date +%H:%M:%S)] $PREAMBLE File successfully altered; proceeding with service execution."
	exit 0
fi
