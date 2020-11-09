#!/bin/bash

#set -x

cd ../jenkins-env

############################################################
# make aws credentials
############################################################
if [ ! -f "/home/vagrant/.aws/credentials" ]; then

	echo aws credentials?
	read -p 'aws_access_key_id: ' aws_access_key_id
	read -sp 'aws_secret_access_key: ' aws_secret_access_key
	echo aws region: us-west-1 
	echo
	
	mkdir -p /home/vagrant/.aws
	
	echo '[default]
	aws_access_key_id = AWS_KEY_ID
	aws_secret_access_key = AWS_SECRET_KEY 
	' > /home/vagrant/.aws/credentials
	
	sed -i "s|AWS_KEY_ID|${aws_access_key_id}|g" /home/vagrant/.aws/credentials
	sed -i "s|AWS_SECRET_KEY|${aws_secret_access_key}|g" /home/vagrant/.aws/credentials
	
	echo '[default]
	region = us-west-1
	output = json
	' > /home/vagrant/.aws/config
	
	chown -Rf vagrant:vagrant /home/vagrant/.aws
	chmod -Rf 600 /home/vagrant/.aws
	
	rm -Rf /root/.aws
	cp -Rf /home/vagrant/.aws /root/.aws
	chmod -Rf 600 /root/.aws
	
	random_str=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-6} | head -n 1`
	aws s3api create-bucket --bucket terraform-state-${random_str} --region us-west-1

fi 

############################################################
## make a ssh key
############################################################
ssh-keygen -t rsa -C mykey -P "" -f mykey -q

rm -Rf backend.tf

############################################################
## make a jenkins instance in aws
############################################################
terraform init
terraform apply -auto-approve

s3_bucket_id=`terraform output | grep s3-bucket | awk '{print $3}'`
app_ip=`terraform output | grep -A 2 "jenkins-ip" | tail -n 1`
app_ip=`echo $app_ip | sed -e 's/\"//g;s/ //;s/,//'`

echo '
Host APP_IP
  StrictHostKeyChecking   no
  LogLevel                ERROR
  UserKnownHostsFile      /dev/null
  IdentitiesOnly yes
' >> ~/.ssh/config

sed -i "s|APP_IP|${app_ip}|g" ~/.ssh/config
jenkins_key=`ssh -i mykey ubuntu@${app_ip} "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"`

echo ############################################################
echo $s3_bucket_id
echo $app_ip
echo "Jenkins url: http://${app_ip}:8080/"
echo "jenkins_key: ${jenkins_key}"
echo ############################################################

cp -Rf backend.tf_imsi  backend.tf
#sed -i "s|XXXX|${s3_bucket_id}|g" backend.tf
terraform init

scp -i mykey scripts/jenkins-projects.sh ubuntu@${app_ip}:/home/ubuntu

scp -i mykey resource/packer-build.xml ubuntu@${app_ip}:/home/ubuntu/config.xml
ssh -i mykey ubuntu@${app_ip} "sudo /bin/bash jenkins-projects.sh packer-build"

scp -i mykey resource/terraform-apply.xml ubuntu@${app_ip}:/home/ubuntu/config.xml
ssh -i mykey ubuntu@${app_ip} "sudo /bin/bash jenkins-projects.sh terraform-apply"

service jenkins restart






