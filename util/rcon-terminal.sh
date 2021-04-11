#!/bin/bash
if [ -z $1 ]; then
	echo -n -e "Please specify the running server to communicate with. The following servers are installed locally:\n\t"
	for i in $(ls /var/minecraft/server/); do
		echo -n "$i "
	done
	echo -e "\nRerun command as rcon-terminal.sh server-name"
	exit 1;
fi

if [ ! -d "/var/minecraft/server/$1" ]; then
	echo "Specified server does not have any files on disk."
	exit 1;
fi
export MCRCON_PORT=$(cat "/var/minecraft/server/$1/server.properties" | grep rcon.port | sed 's/[^0-9]*//g')
export MCRCON_PASS=$(cat "/var/minecraft/server/$1/server.properties" | grep "rcon.password" | sed 's/rcon.password=//')
echo "Connecting to Minecraft server '$1' on RCON port $MCRCON_PORT."
/usr/bin/mcrcon -H 127.0.0.1 -t

exit 0
