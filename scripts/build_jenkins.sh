#!/bin/bash

#set -x

cd /vagrant/jenkins-env

############################################################
# make aws credentials
############################################################
if [ ! -f "/home/vagrant/.aws/config" ]; then

	mkdir -p /home/vagrant/.aws
	sudo cp -Rf /vagrant/jenkins-env/resource/aws/config /home/vagrant/.aws/config
	sudo cp -Rf /vagrant/jenkins-env/resource/aws/credentials /home/vagrant/.aws/credentials
	chown -Rf vagrant:vagrant /home/vagrant/.aws
	chmod -Rf 600 /home/vagrant/.aws/*
	
	rm -Rf /root/.aws
	cp -Rf /home/vagrant/.aws /root/.aws
	chmod -Rf 600 /root/.aws.aws/*

	LC_ALL=C;
	random_str=`cat /dev/urandom | tr -dc 'a-z0-9' | fold -w ${1:-6} | head -n 1`
	echo aws s3api create-bucket --bucket terraform-state-${random_str} --region us-west-1
	aws s3api create-bucket \
	  --bucket terraform-state-${random_str} \
	  --region us-west-1 \
	  --create-bucket-configuration LocationConstraint=us-west-1
fi

sudo rm -Rf .terraform
sudo rm -Rf terraform.tfstate
sudo rm -Rf terraform.tfstate.backup
sudo rm -Rf mykey
sudo rm -Rf backend.tf

############################################################
## make a ssh key
############################################################
ssh-keygen -t rsa -C mykey -P "" -f mykey -q

############################################################
## make a jenkins instance in aws
############################################################
terraform init
terraform apply -auto-approve

export s3_bucket_id=`terraform output | grep s3-bucket | awk '{print $3}'`
jenkins_ip=`terraform output | grep -A 2 "jenkins-ip" | tail -n 1`
export jenkins_ip=`echo $jenkins_ip | sed -e 's/\"//g;s/ //;s/,//'`

echo '
Host JENKINS_IP
  StrictHostKeyChecking   no
  LogLevel                ERROR
  UserKnownHostsFile      /dev/null
  IdentitiesOnly yes
' >> ~/.ssh/config
sed -i "s|JENKINS_IP|${jenkins_ip}|g" ~/.ssh/config

cp -Rf backend.tf_imsi  backend.tf
#sed -i "s|XXXX|${s3_bucket_id}|g" backend.tf
terraform init

echo "ssh -i mykey ubuntu@${jenkins_ip}"

echo "Wait about 2 minutes."
sleep 200

############################################################
## make two jenkins projects
## 1. packer-build -> app build and make an ami
## 2. terraform-apply -> make instance and deploy app
############################################################
scp -i mykey scripts/jenkins-projects.sh ubuntu@${jenkins_ip}:/home/ubuntu

scp -i mykey resource/packer-build.xml ubuntu@${jenkins_ip}:/home/ubuntu/config.xml
ssh -i mykey ubuntu@${jenkins_ip} "sudo /bin/bash jenkins-projects.sh packer-build"

scp -i mykey resource/terraform-apply.xml ubuntu@${jenkins_ip}:/home/ubuntu/config.xml
ssh -i mykey ubuntu@${jenkins_ip} "sudo /bin/bash jenkins-projects.sh terraform-apply"

ssh -i mykey ubuntu@${jenkins_ip} "sudo service jenkins restart"

jenkins_key=`ssh -i mykey ubuntu@${jenkins_ip} "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"`

echo "##[ Summary ]##########################################################"
echo "s3_bucket_id:" $s3_bucket_id
echo "jenkins_ip:" $jenkins_ip
echo "Jenkins url: http://${jenkins_ip}:8080/"
echo "Copy and paste this jenkins_key in the Jenkins url: ${jenkins_key}"
echo ""
echo "Now just run these projects in jenkins like in README.md."
echo "2. run packer-build in jenkins"
echo "3. fix backend.tf in vagrant"
echo "4. run terraform-apply in jenkins"
echo ""
echo "Access to aws ec2 in /vagrant/jenkins-env: ssh -i mykey ubuntu@${jenkins_ip}"
echo "#######################################################################"

