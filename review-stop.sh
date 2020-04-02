#!/bin/bash
sudo docker stack rm $CI_PIPELINE_ID

sudo rm -rf /review/branches/$CI_PIPELINE_ID
