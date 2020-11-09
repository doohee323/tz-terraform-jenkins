#!/bin/bash
set -ex

## cd jenkins-env
cd ..

AWS_REGION="us-west-1"

S3_BUCKET=`aws s3 ls --region $AWS_REGION |grep terraform-state |tail -n1 |cut -d ' ' -f3`
sed -i 's/XXXX/'${S3_BUCKET}'/' backend.tf
sed -i 's/#//g' backend.tf
aws s3 cp s3://${S3_BUCKET}/amivar.tf amivar.tf --region $AWS_REGION
terraform init
terraform apply -auto-approve -var APP_INSTANCE_COUNT=1 -target aws_instance.app-instance

sleep 30

terraform output

