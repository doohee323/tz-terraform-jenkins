#!/bin/bash

cd /vagrant/jenkins-env
terraform destroy -auto-approve

sleep 60

#- mykeypair in Key pairs
aws ec2 delete-key-pair --key-name mykeypair
#- jenkins-role in IAM Roles
aws iam remove-role-from-instance-profile --instance-profile-name jenkins-role --role-name jenkins-role
aws iam delete-instance-profile --instance-profile-name jenkins-role
aws iam delete-role --role-name jenkins-role
policy_name=`aws iam list-role-policies --role-name jenkins-role --output=text | awk '{print $2}'`
aws iam delete-role-policy --role-name jenkins-role --policy-name ${policy_name}

rm -Rf .terraform
rm -Rf terraform.tfstate
rm -Rf terraform.tfstate.backup
rm -Rf mykey
rm -Rf backend.tf

echo "#################################################"
echo "You might need to delete s3 bucket!!"
echo "#################################################"


