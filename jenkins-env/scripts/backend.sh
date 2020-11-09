#!/bin/bash
set -ex

## cd jenkins-env
cd /vagrant/jenkins-env

AWS_REGION="us-west-1"

S3_BUCKET=`aws s3 ls --region $AWS_REGION |grep terraform-state |tail -n1 |cut -d ' ' -f3`
echo "S3_BUCKET: "${S3_BUCKET}
sed -i 's/XXXX/'${S3_BUCKET}'/' backend.tf
sed -i 's/#//g' backend.tf
terraform init
