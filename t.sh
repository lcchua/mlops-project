#!/bin/bash
aws ecr describe-images --repository ce7-grp-1/nonprod/predict_buy_app --region us-east-1 \
	--query "sort_by(imageDetails, &imagePushedAt)[-1].imageTags" --output text | \
	grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+-[A-Z]{3}\.[0-9]+'
