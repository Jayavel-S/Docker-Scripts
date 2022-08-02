# Home Media Server Setup
This script helps you install the latest version of Docker and Docker Compose in Ubuntu/Debian and some essential applications for setting up your home media library.

The list of apps that will be automatically installed are:

- Portainer – For managing the docker applications with a web GUI (https://www.portainer.io/)
- Plex – For organizing and streaming the media content (https://www.plex.tv/)
- Tautulli – A simple tool to monitor plex activity and collect the statistics (https://tautulli.com/)
- Sonarr – A collection manager for web series (https://sonarr.tv/)
- Radarr – A collection manager for movies (https://radarr.video/)
- Sabnzbd – A USENET client/downloader (https://sabnzbd.org/)
- Deluge – A torrent tracker and downloader (https://deluge-torrent.org/)
- Overseerr – A media discovery and request manager for Plex (https://overseerr.dev)
- Jackett – A bridge for apps listed above to communicate with the torrent indexers of your choice (https://github.com/Jackett/Jackett)
- Watchtower – A container to automatically update all the application containers listed above (https://github.com/containrrr/watchtower)

## Prerequisites
 1. You need to have an Ubuntu/Debian-based machine.
 
 2. Your instance should have the updated version of 'git' installed. You can check if you have git installed or not by running the command `git version` and looking at the output.
 
       ![git version](https://user-images.githubusercontent.com/101336634/158008355-768918e3-7ced-462f-9a9f-e52e539c875b.png)
    
    If you do not have git installed, you can use the command `sudo apt update && sudo apt install git` to install the latest version of git in your system.
    
 3. You need to know the PUID and PGID values for the current user. You can get that by running `id` and looking at the first two values. It will most likely be 1000,1000 or 1001,1001 unless you have some special purpose distros.
 
       ![id](https://user-images.githubusercontent.com/101336634/158009775-76741587-43c9-4180-88fb-8484224045cb.png)


## Installation

Open Putty or any ssh tool that you use to connect to your instance. Clone this repository to any directory.

`git clone https://github.com/Jayavel-S/Docker-Scripts` and cd into the parent directory `cd Docker-Scripts`.

---

Here, you'll have three files
- **.env** (Most likely hidden by the system, used to declare the environment variables and the volume mappings)

- **docker-compose.yml** (the compose stack to install Portainer, Sonarr, Radarr, Sabnzbd, Deluge, Overseerr, Jackett, Tautulli, Plex, and Watchtower)

- **setup.sh** (the script to install the docker engine and to set up the dependencies)

---

Before proceeding further, we need to update the environment variables (PUID, PGID, and the Time Zone) and the volume mappings as per your preference. This example uses the 'nano' editor, but you can use any text editor of your choice.

Type in `nano .env` and edit the values as required. You need to update the download directory's path and the directory in which the media resides.

![env](https://user-images.githubusercontent.com/101336634/158014795-95b46d1c-85af-45f7-80ac-85711ab8b2b7.png)

Once you have made the necessary changes, you can press "ctrl+o" and "Enter" and "ctrl+x" to exit the editor. Alternatively, you can also press "ctrl+x" directly and choose 'Yes’.

This will update the .env file with the necessary values. Now, we can start to execute the script.

## Executing the Script:

The script is named as **install.sh**. Run the script with elevated privileges.

**`sudo sh install.sh`**

This will pull the latest version of docker according to the platform you are using (x86/x64/ARM) and install the docker-compose relevant to that binary using python. Depending on your network speed and device specifications, this will take a few minutes.

Once the installation is complete, it is always suggested to reboot the system and check for the status.

`sudo reboot now`, and once the machine is back up, you can go to your Portainer GUI. It defaults to the port **9443**.

Go to `https://(your device's IP address):9443` (Portainer generates an SSL certificate by default in the new version, that's why we use https:// instead of http://)

Once logged in, you need to set up your admin account, and you'll be presented with the dashboard.

![portainer](https://user-images.githubusercontent.com/101336634/158015527-e7d01b42-03b8-4f4f-b0a3-0d343b685a37.png)

The system has successfully processed the docker installation if you see this page. You can now play with your new setup and configure the applications as per your liking.
