#!/bin/bash

git rev-list HEAD > check_master.txt 
remote_master_sha=$(git ls-remote https://gitlab+deploy-token-281128:k8sN7KjmBXXjUKx9CKst@gitlab.com/zisoft/awareness3.1.git HEAD | awk '{ print $1}')

echo "Commit ID of Master: $remote_master_sha"
cat check_master.txt
if grep -Fxq "$remote_master_sha"  ./check_master.txt
then
    echo "Master Merged Successfully" 
    exit 0
else
    echo "Please merge master before push to your branch" 
    exit 1 
fi
