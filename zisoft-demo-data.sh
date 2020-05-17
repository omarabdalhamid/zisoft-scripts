container_web_id="$(sudo docker ps | grep zisoft/awareness/web | awk '{print $1}')"

container_ui_id="$(sudo docker ps | grep zisoft/awareness/ui | awk '{print $1}')"




sudo docker exec -it $container_web_id bash -c "php artisan db:seed --class=init"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson browser 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson email 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson password 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson social 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson wifi 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lesson aml 1 720 prod"

sudo docker exec -it $container_web_id bash -c "php artisan zinad:lessons 720 1 720 prod"


sudo docker exec -it $container_web_id bash -c "php artisan migrate"


sudo docker exec -it $container_web_id bash -c "php artisan zisoft:demo 100 5 30"

sudo docker restart $container_ui_id
