# tz-terraform-jenkins

## 0. Prep
```
	-. make an aws user
	ex) 
	terraform-user with terraform-administrator group

	-. set aws configuration
	vi jenkins-env/resource/aws/config
	vi jenkins-env/resource/aws/credentials

```

## 1. make a working vm in vagrant
```
	scripts/install.sh
	
	install terraform, packer etc

```

## 2. make jenkins env.
```
	scripts/build_jenkins.sh

	- make aws credentials
	- make a ssh key
	- make a jenkins instance in aws
	- make two jenkins projects

	ex) http://54.219.182.238:8080

```

## 3. run build-app in jenkins
```
	ex) http://54.219.182.238:8080/job/build-app/configure
	- Project Name: build-app
	- Git Repository URL: https://github.com/doohee323/tz-terraform-jenkins.git
	- Branches to build: */master
	- Build > Execute shell > Command
		cd ${WORKSPACE}/build-app
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

## 4. run terraform-apply in jenkins
```
	ex) http://54.219.182.238:8080/job/terraform-apply/configure
	- Project Name: terraform-apply
	- Git Repository URL: https://github.com/doohee323/tz-terraform-jenkins.git
	- Branches to build: */master
	- Build > Execute shell > Command
		cd ${WORKSPACE}/jenkins-env/scripts
		bash jenkins-run-terraform.sh
```

## * destroy aws resources
```
	vagrant ssh
	sudo su
	cd /vagrant/jenkins-env
	terraform destroy
	
	Need to delete s3 bucket and ami manually.

```
