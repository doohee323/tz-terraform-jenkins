# tz-terraform-jenkins

## 0. Prep
```
	-. make an aws user
	ex) 
    make a group as terraform-administrator with AdministratorAccess
    make an Programmatic access user as terraform with terraform-administrator
	terraform-user with terraform-administrator group

	-. set aws configuration
	cf. This env. works only in us-west-1.
	vi jenkins-env/resource/aws/config
        [default]
        region = us-west-1
        output = json
	vi jenkins-env/resource/aws/credentials
        [default]
        aws_access_key_id = xxx
        aws_secret_access_key = xxx
```

## 1. vagrant up
```
	cd tz-terraform-jenkins
	vagrant up  # as vagrant user

	It does these steps
	1) make a working vm in vagrant
		scripts/install.sh
		install terraform, packer etc

	2) make jenkins env.
		scripts/build_jenkins.sh
		- make aws credentials
		- make a ssh key
		- make a jenkins instance in aws
		- make two jenkins projects

	Get jenkins url like this, http://54.219.182.238:8080
```

## 2. run packer-build in jenkins
```
	It makes an AMI with packer after building app.
	Run this project After setting like this,

	ex) http://54.219.182.238:8080/job/packer-build/configure
	- Project Name: packer-build
	- Git Repository URL: https://github.com/doohee323/tz-terraform-jenkins.git
	- Branches to build: */master
	- Build > Execute shell > Command
		cd ${WORKSPACE}/packer-build
		bash jenkins-terraform.sh

    # fyi, shells run this automatically,
	# uncomment backend.tf and rename bucket from terraform output
	terraform {
	  backend "s3" {
	    bucket = "XXXX"
	    key    = "terraform.tfstate"
	    region = "us-west-1"
	  }
	}
	$> terraform init
```

## 3. fix backend.tf in vagrant
```
	It should be run in vagrant.
	vagrant ssh
	sudo bash /vagrant/jenkins-env/scripts/backend.sh
```

## 4. run terraform-apply in jenkins
```
	It deploy the app to the instance(s) with terraform.
	Run this project After setting like this,

	ex) http://54.219.182.238:8080/job/terraform-apply/configure
	- Project Name: terraform-apply
	- Git Repository URL: https://github.com/doohee323/tz-terraform-jenkins.git
	- Branches to build: */master
	- Build > Execute shell > Command
		cd ${WORKSPACE}/jenkins-env/scripts
		bash jenkins-run-terraform.sh

	Get the app url.
```

## * destroy aws resources
```
	vagrant ssh
    cd /vagrant/scripts
    bash remove_jenkins.sh
```
