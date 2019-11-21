 
#!/bin/bash
################################################################################
# Script for installing ZiSoft on Ubuntu 14.04, 15.04, 16.04 and 18.04 (could be used for other version too)
# Author: OmarAbdalhamid Omar
#-------------------------------------------------------------------------------
# This script will install ZiSoft Awareness 3 on your Ubuntu 18.04 server. I
#-------------------------------------------------------------------------------
# Make a new file:
# sudo nano zisoft-install.sh
# Place this content in it and then make the file executable:
# sudo chmod +x zisoft-install.sh
# Execute the script to install zisoft:
# ./zisoft-install.sh
################################################################################


read -p "Enter ZiSoft Awareness Release Date :   "   release_date

#--------------------------------------------------
# Clone ZiSoft Awareness Repo
#--------------------------------------------------

sudo mkdir zisoft-test

cd  zisoft-test

sudo git clone https://gitlab.com/omarabdalhamid/awareness_swarm.git --branch $release_date

sudo echo "release_tag=$release_date"  >>  awareness_swarm/.env



#--------------------------------------------------
# Update Server
#--------------------------------------------------

sudo apt-get update -y

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt install gnupg2 pass -y

sudo add-apt-repository universe -y

sudo apt-get update -y

#--------------------------------------------------
# Install Docker & Docker Swarm
#--------------------------------------------------

sudo apt-get install docker-ce -y

sudo apt-get install docker-compose -y

sudo usermod -aG docker ${USER}

sudo docker login registry.gitlab.com

sudo docker swarm init

sudo curl -L https://downloads.portainer.io/portainer-agent-stack.yml -o portainer-agent-stack.yml

sudo docker stack deploy --compose-file=portainer-agent-stack.yml portainer


#--------------------------------------------------
# Perpare ZiSoft Awareness Project
#--------------------------------------------------

sudo docker pull registry.gitlab.com/omarabdalhamid/awareness_swarm/db:20_11_2019

sudo docker pull registry.gitlab.com/omarabdalhamid/awareness_swarm/web:20_11_2019

sudo docker pull registry.gitlab.com/omarabdalhamid/awareness_swarm/cron:20_11_2019

sudo docker pull registry.gitlab.com/omarabdalhamid/awareness_swarm/ui:20_11_2019

sudo docker pull registry.gitlab.com/omarabdalhamid/awareness_swarm/meta:20_11_2019

sudo docker pull registry.gitlab.com/omarabdalhamid/awareness_swarm/worker:20_11_2019

sudo docker pull registry.gitlab.com/omarabdalhamid/awareness_swarm/proxy:20_11_2019

#--------------------------------------------------
# Deploy  ZiSoft Awareness Project
#--------------------------------------------------

sudo docker stack deploy -c <(docker-compose config) zisoft-$release_date

container_web_id="$(sudo docker ps | grep web | awk '{print $1}')"

sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=init"

#--------------------------------------------------
#  ZiSoft Awareness Project  Installed Successfully 
#--------------------------------------------------
