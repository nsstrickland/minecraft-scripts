#!/bin/bash
PREAMBLE="[RCON Script]"
echo "[$(date +%H:%M:%S)] $PREAMBLE Looking up '$1'"
if [ ! -z "$2" ]; then
	echo "[$(date +%H:%M:%S)] $PREAMBLE PID provided via pipe: $2"
fi

if [ $1 = 'default' ]; then
	inst=$(systemctl -p MainPID show "minecraft.service" | sed 's/[^0-9]*//g')
	export MCRCON_PORT='25566'
	echo "[$(date +%H:%M:%S)] $PREAMBLE Sending stop command to minecraft.service."
else
	export MCRCON_PORT=$(cat "/var/minecraft/server/$1/server.properties" | grep "rcon.port" | sed 's/[^0-9]*//g')
	export MCRCON_PASS=$(cat "/var/minecraft/server/$1/server.properties" | grep "rcon.password" | sed 's/rcon.password=//')
	echo "$MCRCON_PASS is the password for this server"
	if [ -z "$2" ]; then
		inst=$(systemctl -p MainPID show "minecraft@$1.service" | sed 's/[^0-9]*//g')
	else
		inst=$2
	fi
fi
echo "[$(date +%H:%M:%S)] $PREAMBLE PID: $inst RCON port: $MCRCON_PORT"
echo "[$(date +%H:%M:%S)] $PREAMBLE Sending 'save-all' command to server."
/usr/bin/mcrcon -H 127.0.0.1 "save-all"
echo "[$(date +%H:%M:%S)] $PREAMBLE Sending shutdown warning message to server."
COUNTDOWN=30
while [ $COUNTDOWN -gt 0 ]; do
	/usr/bin/mcrcon -H 127.0.0.1 "say Server will be shutting down in §4$COUNTDOWN§f seconds."
	COUNTDOWN=$(expr $COUNTDOWN - 10)
	sleep 10
done
sleep 15
echo "[$(date +%H:%M:%S)] $PREAMBLE Sending stop command to minecraft@$1.service."
/usr/bin/mcrcon -H 127.0.0.1 "say Server shutting down."
ExecKill="/usr/bin/mcrcon -H 127.0.0.1 stop"
$ExecKill
echo "[$(date +%H:%M:%S)] $PREAMBLE Waiting for PID $inst to close."
STATUS=$(/usr/bin/ps -p $inst --no-headers | wc -l)
while [ "$STATUS" -gt 0 ]; do
	$ExecKill
	sleep 15
	STATUS=$(/usr/bin/ps -p $inst --no-headers | wc -l)
done

echo "[$(date +%H:%M:%S)] $PREAMBLE $inst has exited."
exit 0
