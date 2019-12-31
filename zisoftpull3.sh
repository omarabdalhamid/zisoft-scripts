
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

sudo docker login registry.gitlab.com -u omarabdalhamid -p omaRR**1990
sudo docker swarm init


docker pull registry.gitlab.com/zisoft/image/awareness/worker-3-package
docker pull registry.gitlab.com/zisoft/image/awareness/ui-3-package
docker pull registry.gitlab.com/zisoft/image/awareness/web-3-package
docker pull registry.gitlab.com/zisoft/image/awareness/cron-3-package
docker pull registry.gitlab.com/zisoft/image/awareness/db-3-package
docker pull registry.gitlab.com/zisoft/image/awareness/proxy-3-package
docker pull registry.gitlab.com/zisoft/image/awareness/meta-3-package

sudo mkdir /zisoft 
cd /zisoft

wget https://raw.githubusercontent.com/omarabdalhamid/zisoft-scripts/master/docker-compose.yml

sudo docker stack deploy -c docker-compose zisoft3
