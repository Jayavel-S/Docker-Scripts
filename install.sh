#!/bin/bash

installApps()
{
    clear
    OS="$REPLY" ## <-- This $REPLY is about OS Selection
    echo "This script will help you in installing the latest version of Docker-CE, Docker-Compose, and Portainer-CE."
    echo "Please select 'y' for the items you would like to install."
    echo "NOTE: Without Docker you cannot use Docker-Compose, or Portainer-CE."
    echo "       You also must have Docker-Compose and Portainer for other apps to be installed."
    echo ""
    echo ""
    
    ISACT=$( (sudo systemctl is-active docker ) 2>&1 )
    ISCOMP=$( (docker-compose -v ) 2>&1 )

    #### Try to check whether docker is installed and running - don't prompt if it is
    if [[ "$ISACT" != "active" ]]; then
        read -rp "Docker-CE (y/n): " DOCK
    else
        echo "Docker appears to be installed and running."
        echo ""
        echo ""
    fi

    if [[ "$ISCOMP" == *"command not found"* ]]; then
        read -rp "Docker-Compose (y/n): " DCOMP
    else
        echo "Docker-compose appears to be installed."
        echo ""
        echo ""
    fi

    read -rp "Portainer-CE (y/n): " PTAIN
    read -rp "Media-Server Essentials (y/n): " MSE
    read -rp "Plex (y/n): " PLEX
    read -rp "Jellyfin (y/n): " JFN
    
    if [[ "$PTAIN" == [yY] ]]; then
        echo ""
        echo ""
        PS3="Please choose either Portainer-CE or just Portainer Agent: "
        select _ in \
            " Full Portainer-CE (Web GUI for Docker, Swarm, and Kubernetes)" \
            " Portainer Agent - Remote Agent to Connect from Portainer-CE" \
            " Skip Portainer installation."
        do
            PORT="$REPLY"
            case $REPLY in
                1) startInstall ;;
                2) startInstall ;;
                3) startInstall ;;
                *) echo "Invalid selection, please try again." ;;
            esac
        done
    fi
    
    startInstall
}

startInstall() 
{
    clear
    echo "#######################################################"
    echo "###         Preparing for Installation              ###"
    echo "#######################################################"
    echo ""
    sleep 3s

    #######################################################
    ###           Install for Debian / Ubuntu           ###
    #######################################################

    if [[ "$OS" != "1" ]]; then
        echo "    1. Installing System Updates. This may take a while."
        (sudo apt update && sudo apt upgrade -y && sudo apt install lsb-core) > ~/docker-script-install.log 2>&1 &
        ## Show a spinner for activity progress
        pid=$! # Process Id of the previous running command
        spin='-\|/'
        i=0
        while kill -0 $pid 2>/dev/null
        do
            i=$(( (i+1) %4 ))
            printf "\r${spin:$i:1}"
            sleep .1
        done
        printf "\r"
        # echo "    2. Install Prerequisite Packages..."
        # sleep 2s

        # sudo apt install apt-transport-https ca-certificates curl software-properties-common -y >> ~/docker-script-install.log 2>&1

        # if [[ "$DOCK" == [yY] ]]; then
        #     echo "    3. Retrieving Signing Keys for Docker... and adding the Docker-CE repository..."
        #     sleep 2s

        #     #### add the Debian 10 Buster key
        #     if [[ "$OS" == 2 ]]; then
        #         curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - >> ~/docker-script-install.log 2>&1
        #         sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" -y >> ~/docker-script-install.log 2>&1
        #     fi

        #     if [[ "$OS" == 3 ]] || [[ "$OS" == 4 ]]; then
        #         curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - >> ~/docker-script-install.log 2>&1

        #         sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y >> ~/docker-script-install.log 2>&1
        #     fi

        #     sudo apt update >> ~/docker-script-install.log 2>&1
        #     sudo apt-cache policy docker-ce >> ~/docker-script-install.log 2>&1

            echo "    2. Installing Docker-CE (Community Edition)."
            sleep 2s

            #sudo apt install docker-ce -y >> ~/docker-script-install.log 2>&1

            curl -fsSL https://get.docker.com | sh >> ~/docker-script-install.log 2>&1

                echo "- docker-ce version is now:"
            docker -v
            sleep 5s

            if [[ "$OS" == 2 ]]; then
                echo "    5. Starting Docker Service"
                sudo systemctl docker start >> ~/docker-script-install.log 2>&1
            fi
        # fi
    fi
        
    
    #######################################################
    ###              Install for CentOS 7 or 8          ###
    #######################################################
    if [[ "$OS" == "1" ]]; then
        if [[ "$DOCK" == [yY] ]]; then
            echo "    1. Updating System Packages."
            sudo yum install curl
            sudo yum install redhat-lsb-core
            sudo yum check-update >> ~/docker-script-install.log 2>&1

            echo "    2. Installing Docker-CE (Community Edition)."

            sleep 2s
            (curl -fsSL https://get.docker.com/ | sh) >> ~/docker-script-install.log 2>&1

            echo "    3. Starting the Docker Service."

            sleep 2s

            sudo systemctl start docker >> ~/docker-script-install.log 2>&1

            echo "    4. Enabling the Docker Service."
            sleep 2s

            sudo systemctl enable docker >> ~/docker-script-install.log 2>&1
        fi
    fi

    #######################################################
    ###               Install for Arch Linux            ###
    #######################################################

    if [[ "$OS" == "5" ]]; then
        read -rp "Do you want to install system updates prior to installing Docker-CE? (y/n): " UPDARCH
        if [[ "UPDARCH" == [yY] ]]; then
            echo "    1. Installing System Updates. This may take a while."
            (sudo pacman -Syu) > ~/docker-script-install.log 2>&1 &
            ## Show a spinner for activity progress
            pid=$! # Process Id of the previous running command
            spin='-\|/'
            i=0
            while kill -0 $pid 2>/dev/null
            do
                i=$(( (i+1) %4 ))
                printf "\r${spin:$i:1}"
                sleep .1
            done
            printf "\r"
        else
            echo "    1. Skipping system update..."
            sleep 2s
        fi

        echo "    2. Installing Docker-CE (Community Edition)..."
            sleep 2s

            sudo pacman -Syu lsb-release
            
            curl -fsSL https://get.docker.com | sh >> ~/docker-script-install.log 2>&1

            echo "    - docker-ce version is now:"
            docker -v
            sleep 5s

        echo "    3. Starting the Docker Service."

            sleep 2s

            sudo systemctl start docker.service >> ~/docker-script-install.log 2>&1

            echo "    4. Enabling the Docker Service."
            sleep 2s

            sudo systemctl enable docker.service >> ~/docker-script-install.log 2>&1
    fi

    if [[ "$DOCK" == [yY] ]]; then
        # add current user to docker group so sudo isn't needed
        echo ""
        echo "  - Adding the currently logged in user to the docker group."

        sleep 2s
        sudo usermod -aG docker "${USER}" >> ~/docker-script-install.log 2>&1
        echo "  - You'll need to log out and back in to finalize the addition of your user to the docker group."
        echo ""
        echo ""
        sleep 3s
    fi

    if [[ "$DCOMP" = [yY] ]]; then
        echo "############################################"
        echo "#####    Installing Docker-Compose    #####"
        echo "############################################"

        # install docker-compose
        echo ""
        echo "    1. Installing Docker-Compose."
        echo ""
        echo ""
        sleep 2s

        ######################################
        ###     Install Debian / Ubuntu    ###
        ######################################        
        
        if [[ "$OS" != "1" ]]; then
            COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
            sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
            sudo chmod +x /usr/local/bin/docker-compose
            sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose" >> ~/docker-script-install.log 2>&1
        fi

        ######################################
        ###        Install CentOS 7        ###
        ######################################

        if [[ "$OS" == "1" ]]; then
            sudo yum update -y
            sudo yum upgrade
            sudo yum install curl
            COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
            sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose

        #    COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
        #    sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose" >> ~/docker-script-install.log 2>&1
        #    sudo chmod +x /usr/local/bin/docker-compose
        #    sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose" >> ~/docker-script-install.log 2>&1        
            
        fi

        #######################################################
        ###               Install for Arch Linux            ###
        #######################################################

        if [[ "$OS" == "5" ]]; then
            sudo pacman -Sy
            sudo pacman -Syu docker-compose
        fi

        echo ""

        echo "- Docker Compose Version is now: " 
        docker compose version
        echo ""
        echo ""
        sleep 3s
    fi

    ##########################################
    #### Test if Docker Service is Running ###
    ##########################################
    ISACT=$( (sudo systemctl is-active docker ) 2>&1 )
    if [[ "$ISACt" != "active" ]]; then
        echo "Docker is starting"
        while [[ "$ISACT" != "active" ]] && [[ $X -le 10 ]]; do
            sudo systemctl start docker >> ~/docker-script-install.log 2>&1
            sleep 10s &
            pid=$! # Process Id of the previous running command
            spin='-\|/'
            i=0
            while kill -0 $pid 2>/dev/null
            do
                i=$(( (i+1) %4 ))
                printf "\r${spin:$i:1}"
                sleep .1
            done
            printf "\r"
            ISACT=`sudo systemctl is-active docker`
            let X=X+1
            echo "$X"
        done
    fi

    if [[ "$MSE" == [yY] ]]; then
        echo "###########################################"
        echo  "###  Install Media-Server Essentials  ###"
        echo "###########################################"
    
        # pull the necessary docker-compose file from github
        echo "    1. Pulling the docker-compose.yml file."

        sudo mkdir /data/docker/configs -p
        sudo mkdir /home/downloads -p
        sudo mkdir /home/downloads/tv -p
        sudo mkdir /home/downloads/movies -p
        sudo mkdir -p docker/essentials_applications
        cd docker/essentials_applications

        curl https://github.com/Jayavel-S/Docker-Scripts/blob/main/Compose_Media_Essentials.yml -o docker-compose.yml >> ~/docker-script-install.log 2>&1

        echo "    2. Running the docker-compose.yml to install and start the applications"
        echo ""
        echo ""

        if [[ "$OS" == "1" ]]; then
          docker-compose up -d
        fi

        if [[ "$OS" != "1" ]]; then
          sudo docker-compose up -d
        fi

        echo ""
        echo ""
        echo "    Navigate to your server hostname / IP address on port 9443 to login to portainer"
        echo "    and check the status of the applications."
        echo ""
        echo ""       
        sleep 3s
        cd
    fi

    if [[ "$PORT" == "1" ]]; then
        echo "########################################"
        echo "###      Installing Portainer-CE     ###"
        echo "########################################"
        echo ""
        echo "    1. Preparing to Install Portainer-CE"
        echo ""
        echo ""

        sudo docker volume create portainer_data
        sudo docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
        echo ""
        echo ""
        echo "    Navigate to your server hostname / IP address on port 9443 and create your admin account for Portainer-CE"

        echo ""
        echo ""
        echo ""
        sleep 3s
    fi

    if [[ "$PORT" == "2" ]]; then
        echo "###########################################"
        echo "###      Installing Portainer Agent     ###"
        echo "###########################################"
        echo ""
        echo "    1. Preparing to install Portainer Agent"

        sudo docker volume create portainer_data
        sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent
        echo ""
        echo ""
        echo "    From Portainer or Portainer-CE add this Agent instance via the 'Endpoints' option in the left menu."
        echo "       ####     Use the IP address of this server and port 9001"
        echo ""
        echo ""
        echo ""
        sleep 3s
    fi

    if [[ "$PLEX" == [yY] ]]; then
        echo "###########################################"
        echo "###          Installing PLEX            ###"
        echo "###########################################"
        echo ""
        echo "    1. Preparing to install PLEX"

        mkdir -p docker/plex
        cd docker/Plex

        curl https://github.com/Jayavel-S/Docker-Scripts/blob/main/Compose_Plex.yml -o docker-compose.yml >> ~/docker-script-install.log 2>&1

        echo "    2. Running the docker-compose.yml to install and start Plex"
        echo ""
        echo ""

        if [[ "$OS" == "1" ]]; then
          docker-compose up -d
        fi

        if [[ "$OS" != "1" ]]; then
          sudo docker-compose up -d
        fi

        echo ""
        echo ""
        echo "    Navigate to your server hostname / IP address on port 32400 to setup"
        echo "    your new Plex instance."
        echo ""      
        sleep 3s
        cd
    fi

    if [[ "$JFN" == [yY] ]]; then
        echo "###########################################"
        echo "###         Installing Jellyfin         ###"
        echo "###########################################"
        echo ""
        echo "    1. Preparing to install Jellyfin"

        mkdir -p docker/Jellyfin
        cd docker/Jellyfin

        curl https://github.com/Jayavel-S/Docker-Scripts/blob/main/Compose_Jellyfin.yml -o docker-compose.yml >> ~/docker-script-install.log 2>&1

        echo "    2. Running the docker-compose.yml to install and start Jellyfin"
        echo ""
        echo ""

        if [[ "$OS" == "1" ]]; then
          docker-compose up -d
        fi

        if [[ "$OS" != "1" ]]; then
          sudo docker-compose up -d
        fi

        echo ""
        echo ""
        echo "    Navigate to your server hostname / IP address on port 8096 to setup"
        echo "    your new Jellyfin instance."
        echo ""      
        sleep 3s
        cd
    fi

    exit 1
}

echo ""
echo ""

clear

echo "You appear to be running"
echo ""
echo ""
echo "    From some basic information on your system, you appear to be running: "
echo "        --  OpSys        " $(lsb_release -i)
echo "        --  Desc:        " $(lsb_release -d)
echo "        --  OSVer        " $(lsb_release -r)
echo "        --  CdNme        " $(lsb_release -c)
echo ""
echo "------------------------------------------------"
echo ""
PS3="Please select the appropriate number for your OS/Distro: "
select _ in \
    "CentOS 7 and 8" \
    "Debian 10/11 (Buster / Bullseye)" \
    "Ubuntu 18.04 (Bionic)" \
    "Ubuntu 20.04 / 21.04 / 22.04 (Focal / Hirsute / Jammy)" \
    "Arch Linux" \
    "End this Installer"
do
  case $REPLY in
    1) installApps ;;
    2) installApps ;;
    3) installApps ;;
    4) installApps ;;
    5) installApps ;;
    6) exit ;;
    *) echo "Invalid selection, try again." ;;
  esac
done
