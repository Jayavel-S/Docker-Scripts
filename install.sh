echo "This script will help you in installing the latest version of docker and docker-compose along with media applications in Ubuntu"
echo ""
echo "You appear to be running the following distribution:"
echo ""
echo " " "$(lsb_release -i)"
echo " " "$(lsb_release -d)"
echo " " "$(lsb_release -r)"
echo " " "$(lsb_release -c)"
echo ""
echo "------------------------------------------------"
echo ""

# Caching sudo access for install completion
sudo true

echo "  Installing System Updates. This may take a while."
            export DEBIAN_FRONTEND=noninteractive
            sudo apt update && sudo apt upgrade -y
                
echo "  Installing Docker (Community Edition)."
        sleep 2s
            wget -qO- https://get.docker.com/ | sh

        echo "- docker-ce version is now:"
            docker -v
        sleep 2s

# Adding User Permissions
            sudo usermod -aG docker "${USER}"

# Enabling docker to start automatically on hardware reboot            
            sudo systemctl enable docker
            sudo systemctl start docker

echo "    Installing Docker-Compose."

# Install the prerequisites for setting up docker-compose
        sudo apt-get install -y libffi-dev libssl-dev
        sudo apt-get install -y python3-dev
        sudo apt-get install -y python3 python3-pip

# Installing docker-compose using pip3
        sudo pip3 install docker-compose

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
        echo ""

echo "###########################################"
echo  "###  Install Media-Server Essentials  ###"
echo "###########################################"
        # pull the necessary docker-compose file from github
echo "  1. Pulling the docker-compose.yml file."
       
        sudo mkdir /data/docker/configs -p
        sudo mkdir /home/downloads -p
        sudo mkdir /home/downloads/tv -p
        sudo mkdir /home/downloads/movies -p
              
        echo "    2. Running the docker-compose.yml to install and start the applications"

        sudo docker-compose up -d

        echo ""
        echo ""
        echo "    Navigate to your server hostname / IP address on port 9443 to login to portainer"
        echo "    and check the status of the applications."
        echo ""
        echo ""
