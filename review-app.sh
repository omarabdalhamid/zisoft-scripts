#!/bin/bash
cd /review/branches/
mkdir $CI_PIPELINE_ID 
cd $CI_PIPELINE_ID
wget https://zi-kube.s3-us-west-2.amazonaws.com/review.zip
unzip -q review.zip

cd review/awareness/

sudo docker stack deploy -c docker-compose.offline.linux.yml $CI_PIPELINE_ID

sleep 30

service_id="$(sudo docker service ls  | grep $CI_PIPELINE_ID | grep proxy | awk '{print $1}')"

port_id="$(sudo docker inspect --format='{{.Endpoint.Ports}}' $service_id | awk '{print $4}')"

sed -i "s/pipelineid/$CI_PIPELINE_ID/g" review-nginx
sed -i "s/5001/$port_id/g" review-nginx
mv review-nginx $CI_PIPELINE_ID.review-app.zisoft.org
sudo cp $CI_PIPELINE_ID.review-app.zisoft.org /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/$CI_PIPELINE_ID.review-app.zisoft.org /etc/nginx/sites-enabled/ 
sudo service nginx restart
