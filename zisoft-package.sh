#!/bin/bash
################################################################################
# Script for installing ZiSoft on Ubuntu 14.04, 15.04, 16.04 and 18.04 (could be used for other version too)
# Author: OmarAbdalhamid Omar
#-------------------------------------------------------------------------------
# This script will install ZiSoft Awareness 3 on your Ubuntu 18.04 server. I
#-------------------------------------------------------------------------------
# Make a new file:
# sudo nano zisoft-package.sh
# Place this content in it and then make the file executable:
# sudo chmod +x zisoft-install.sh
# Execute the script to install zisoft:
# ./zisoft-package.sh
################################################################################


package_date= eval $(echo date +"%Hh_%Mm_%m_%d_%y")

echo $package_date


container_web_id="$(sudo docker ps | grep zisoft/awareness/web | awk '{print $1}')"

container_ui_id="$(sudo docker ps | grep zisoft/awareness/ui | awk '{print $1}')"

container_worker_id="$(sudo docker ps | grep zisoft/awareness/woroker | awk '{print $1}')"

container_cron_id="$(sudo docker ps | grep zisoft/awareness/cron | awk '{print $1}')"

container_db_id="$(sudo docker ps | grep zisoft/awareness/db | awk '{print $1}')"

container_proxy_id="$(sudo docker ps | grep zisoft/awareness/proxy | awk '{print $1}')"

container_meta_id="$(sudo docker ps | grep zisoft/awareness/meta | awk '{print $1}')"


sudo docker commit container_web_id  registry.gitlab.com/omarabdalhamid/awareness_swarm/web:$package_date

sudo docker commit  container_ui_id registry.gitlab.com/omarabdalhamid/awareness_swarm/ui:$package_date

sudo docker commit  container_worker_id registry.gitlab.com/omarabdalhamid/awareness_swarm/worker:$package_date

sudo docker commit container_cron_id  registry.gitlab.com/omarabdalhamid/awareness_swarm/cron:$package_date

sudo docker commit  container_meta_id registry.gitlab.com/omarabdalhamid/awareness_swarm/db:$package_date

sudo docker commit  container_proxy_id registry.gitlab.com/omarabdalhamid/awareness_swarm/proxy:$package_date

sudo docker commit  container_meta_id registry.gitlab.com/omarabdalhamid/awareness_swarm/meta:$package_date



sudo docker push registry.gitlab.com/omarabdalhamid/awareness_swarm/web:$package_date

sudo docker push registry.gitlab.com/omarabdalhamid/awareness_swarm/ui:$package_date

sudo docker push registry.gitlab.com/omarabdalhamid/awareness_swarm/worker:$package_date

sudo docker push  registry.gitlab.com/omarabdalhamid/awareness_swarm/cron:$package_date

sudo docker push registry.gitlab.com/omarabdalhamid/awareness_swarm/db:$package_date

sudo docker push registry.gitlab.com/omarabdalhamid/awareness_swarm/proxy:$package_date

sudo docker push registry.gitlab.com/omarabdalhamid/awareness_swarm/meta:$package_date
