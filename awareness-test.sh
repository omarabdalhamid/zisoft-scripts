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
echo -e "\n--- Installing ZiSoft branch --"

read -p "Enter ZiSoft Awareness  Branch Name :   "  release_date



#--------------------------------------------------
# Clone ZiSoft Awareness Repo
#--------------------------------------------------

echo -e "\n--- Clone ZiSoft branch --"


sudo mkdir zisoft-test
cd  zisoft-test
sudo git clone https://gitlab.com/zisoft/awareness.git --branch $release_date


#--------------------------------------------------
# Update Server
#--------------------------------------------------

echo -e "\n--- Download Docker Repositry --"


sudo apt-get update -y
sudo apt install npm -y
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

#--------------------------------------------------
# Run npm Package of ZiSoft CLI
#--------------------------------------------------
echo -e "\n--- Download NPM Repositry --"


cd awareness/cli
sudo npm update
sudo npm link
cd ..

#--------------------------------------------------
# Build && Package  ZiSoft Awareness Project
#--------------------------------------------------
echo -e "\n--- Build ZiSoft APP--"


sudo zisoft build --docker --sass --app --ui --composer

echo -e "\n--- Package ZiSoft APP--"


sudo zisoft package

#--------------------------------------------------
# Deploy  ZiSoft Awareness Project
#--------------------------------------------------

echo -e "\n--- Deploy ZiSoft APP--"


sudo zisoft deploy --prod

container_web_id="$(sudo docker ps | grep web | awk '{print $1}')"

sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=init"

#--------------------------------------------------
#  ZiSoft Awareness Project  Installed Successfully 
#--------------------------------------------------

