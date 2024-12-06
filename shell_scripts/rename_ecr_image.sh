#!/bin/bash
repo_env=$1
current_tag=$2
new_tag=$3
echo $repo_env $current_tag $new_tag

docker pull 255945442255.dkr.ecr.us-east-1.amazonaws.com/ce7-grp-1/$repo_env/predict_buy_app:$current_tag

docker tag 255945442255.dkr.ecr.us-east-1.amazonaws.com/ce7-grp-1/$repo_env/predict_buy_app:$current_tag 255945442255.dkr.ecr.us-east-1.amazonaws.com/ce7-grp-1/$repo_env/predict_buy_app:$new_tag

docker push 255945442255.dkr.ecr.us-east-1.amazonaws.com/ce7-grp-1/$repo_env/predict_buy_app:$new_tag

aws ecr batch-delete-image --repository-name ce7-grp-1/$repo_env/predict_buy_app --image-ids imageTag=$current_tag
