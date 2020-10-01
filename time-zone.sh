#!/bin/bash
################################################################################
# Author: OmarAbdalhamid Omar
# Mail: o.abdalhamid@entrenchtech.com
#-------------------------------------------------------------------------------
# This script will load demo data for ZiSoft Awareness 3 . I
#-------------------------------------------------------------------------------
# Make a new file:
# sudo nano time-zone.sh
# Place this content in it and then make the file executable:
# sudo chmod +x time-zone.sh
# Execute the script to install zisoft:
# ./time-zone.sh
################################################################################



container_web_id="$(sudo docker ps | grep staging_web | awk '{print $1}')"

container_cron_id="$(sudo docker ps | grep staging_cron | awk '{print $1}')"

container_db_id="$(sudo docker ps | grep staging_db | awk '{print $1}')"


##### update web container timezone #####

sudo docker exec -it $container_web_id bash -c "rm -rf /etc/localtime"

sudo docker exec -it $container_web_id bash -c "cp  /usr/share/zoneinfo/Asia/Riyadh  /etc/localtime"


##### update cron container timezone #####

sudo docker exec -it $container_cron_id sh -c "apk add curl"

sudo docker exec -it $container_cron_id sh -c "apk add tzdata"

sudo docker exec -it $container_cron_id sh -c "rm -rf /etc/localtime"

sudo docker exec -it $container_cron_id sh -c "cp  /usr/share/zoneinfo/Asia/Riyadh  /etc/localtime"


##### update db container timezone #####

sudo docker exec -it $container_db_id bash -c "echo 'Asia/Riyadh' > /etc/timezone"

sudo docker exec -it $container_db_id bash -c "dpkg-reconfigure -f noninteractive tzdata"

####### Commit KAS time zone Changes ######

docker commit $container_web_id entrench/awareness_3.1_sa_web

docker commit $container_cron_id entrench/awareness_3.1_sa_cron

docker commit $container_db_id entrench/awareness_3.1_sa_db


