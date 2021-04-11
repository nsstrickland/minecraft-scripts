<h1 align="center">
    <img src="backup/services/server-icon.png" height="64"><br>
    Strick.Land Server Scripts
</h1>

<p align="center"><strong>A collection of scripts used for my personal minecraft server</p>
<p align="center"> Constantly improving, but never really that good!</p>

## Files and Descriptions
### Util
Main collection of scripts for server upkeep
- `backup.sh`
    - Backup script that informs the server of potential incoming lag, then compresses all files into a `.tar.gz` file named with the time and server name. 
    - Removes  files older than a certain amount of time
- `rcon-gen-pass.sh`
    - Basically useless, but generates a random password for the rcon terminal.
    - Runs each time a server is started for a unique password every time.
- `rcon-stop-server.sh`
    - Warns a server for 30 seconds before stopping, then saves worlds before stopping server.
    - SystemD unit provides PID to script (though the script can look this up if not given), the script will watch until the PID disappears, then successfully exit.
- `rcon-terminal.sh`
    - Based on the server name, quickly looks up the rcon port and password, then starts an `mcrcon` terminal with the relevant information
### Backup/services
systemd units for minecraft services
- minecraft-announce.service
    - A service to run the `LANBroadcast.py` script under `util`
