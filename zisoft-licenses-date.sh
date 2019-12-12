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
# sudo chmod +x zisoft-licenses.sh
# Execute the script to install zisoft:
# ./zisoft-licenses.sh
################################################################################

echo "\n#############################################"

echo  "\n--- Generate ZiSoft Licenses --"

echo "\n#############################################"

read -p "Enter ZiSoft Awareness  Client Name :   "  client_name
echo "\n"

read -p "Enter  Number of Users :   "  client_users
echo "\n"

read -p "Enter Number of Phishing_Users :   "  phishing_users
echo "\n"

read -p "Enter End date (YYYY-MM-DD) :   "  end_date
echo "\n"

read -p "Enter Phishing date (YYYY-MM-DD) :   "  phishing_date
echo "\n"

container_web_id="$(sudo docker ps | grep zisoft/awareness/web | awk '{print $1}')"

sudo docker exec -it $container_web_id bash -c "php artisan zisoft:license_create $client_name $end_date $client_users $phishing_date $phishing_users"


echo "\n#############################################"

echo  "\n---  ZiSoft Licenses Created Successfully --"
 
echo "\n#############################################"

echo "\n Licenses Import instructions"

echo "\n 1 - Copy Licenses Activation Key"
echo "\n 2 - Login   with an admin account"
echo "\n 3 - Go to Administrator -> Settings -> Licenses"
echo "\n 4 - Click + Import License"
echo '\n 5 - paste the activation key which looks like {"users": X, "client": XXXX, "date": XXXX}XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
echo "\n 6 - Click Save"







