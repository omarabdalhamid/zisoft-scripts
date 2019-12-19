
echo "\n#############################################"

echo  "\n--- Download Docker Repositry --"


echo "\n#############################################"

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

sudo docker login registry.gitlab.com -u omarabdalhamid -p omaRR**1990
sudo docker swarm init





mkdir /zi-app/
cd /zi-app/
wget https://raw.githubusercontent.com/omarabdalhamid/zisoft-scripts/master/docker-compose.yml 


docker login registry.gitlab.com -u omarabdalhamid -p omaRR**1990

docker pull registry.gitlab.com/zisoft/image/awareness/web-3-package:latest
docker pull registry.gitlab.com/zisoft/image/awareness/worker-3-package:latest
docker pull registry.gitlab.com/zisoft/image/awareness/db-3-package:latest
docker pull registry.gitlab.com/zisoft/image/awareness/cron-3-package:latest
docker pull registry.gitlab.com/zisoft/image/awareness/ui-3-package:latest
docker pull registry.gitlab.com/zisoft/image/awareness/meta-3-package:latest

docker stack deploy -c docker-compose.yml  awareness

sleep 3m

container_web_id="$(sudo docker ps | grep web-3-package | awk '{print $1}')"

container_ui_id="$(sudo docker ps | grep ui-3-package: | awk '{print $1}')"

sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=DropRecreateDB"


sudo docker exec -it $container_web_id bash -c "php artisan migrate"


sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=init"


sudo docker exec -it $container_web_id bash -c "php artisan zisoft:demo 100 5 30"

sudo docker restart $container_ui_id




