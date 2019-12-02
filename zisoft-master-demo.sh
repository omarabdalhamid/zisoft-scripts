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



#--------------------------------------------------
# Clone ZiSoft Awareness Repo
#--------------------------------------------------

echo "\n#############################################"

echo "\n--- Clone ZiSoft branch --"

echo "\n#############################################"


sudo mkdir zisoft-test
cd  zisoft-test
sudo git clone https://gitlab.com/zisoft/awareness.git --branch 



#--------------------------------------------------
# Update Server
#--------------------------------------------------


echo "\n#############################################"

echo  "\n--- Download Docker Repositry --"


echo "\n#############################################"

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

echo "\n#############################################"

echo  "\n--- Download NPM Packages --"

echo "\n#############################################"


cd awareness/cli
sudo npm update
sudo npm link
cd ..

#--------------------------------------------------
# Build && Package  ZiSoft Awareness Project
#--------------------------------------------------

echo "\n#############################################"

echo "\n--- Build ZiSoft APP--"


echo "\n#############################################"


sudo zisoft build --docker --sass --app --ui --composer

echo -e "\n--- Package ZiSoft APP--"


sudo zisoft package


#--------------------------------------------------
# Deploy  ZiSoft Awareness Project
#--------------------------------------------------

echo "\n#############################################"


echo  "\n--- Deploy ZiSoft APP--"


echo "\n#############################################"

sudo zisoft deploy --prod

sleep 3m

container_web_id="$(sudo docker ps | grep zisoft/awareness/web | awk '{print $1}')"

container_ui_id="$(sudo docker ps | grep zisoft/awareness/ui | awk '{print $1}')"



sudo docker exec -it $container_web_id bash -c 'sed -i "/zinad:lessons/a '\''campaign1'\'' => 1"  app/Console/Commands/Demo.php'

sudo docker exec -it $container_web_id bash -c 'sed -i "/zinad:lessons/a '\''mode'\'' => '\''none'\'',"  app/Console/Commands/Demo.php'

sudo docker exec -it $container_web_id bash -c 'sed -i "/zinad:lessons/a '\''resolution'\'' => '\''720'\'',"  app/Console/Commands/Demo.php'

sudo docker exec -it $container_web_id bash -c 'sed -i "/zinad:lessons/a '\''version'\'' => 1,"  app/Console/Commands/Demo.php'


sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=init"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson browser 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson email 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson password 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson social 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson wifi 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson aml 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lessons 720 1 720 prod"



sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=DropRecreateDB"


sudo docker exec -it $container_web_id bash -c "php artisan migrate"


sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=init"


sudo docker exec -it $container_web_id bash -c "php artisan zisoft:demo 100 5 30"

sudo docker restart $container_ui_id

curl -L https://downloads.portainer.io/portainer-agent-stack.yml -o portainer-agent-stack.yml

sudo docker stack deploy --compose-file=portainer-agent-stack.yml portainer

#--------------------------------------------------
#  ZiSoft Awareness Project  Installed Successfully 
#--------------------------------------------------

echo "\n#############################################"


echo "\n-----ZiSoft Awareness Project  Installed Successfully ----"


echo "\n#############################################"

