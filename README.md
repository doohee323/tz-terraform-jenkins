# tz-terraform-jenkins

## 0. make an aws user
```
	ex) 
	terraform-user with terraform-administrator group
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

## 3. run packer-build in jenkins
```
	ex) http://54.219.182.238:8080/job/packer-build/configure
	packer-build
	https://github.com/doohee323/tz-terraform-jenkins.git
	cd ${WORKSPACE}/packer-build
	bash jenkins-terraform.sh
```

## 4. uncomment backend.tf and rename bucket from terraform output
```
	terraform {
	  backend "s3" {
	    bucket = "XXXX"
	    key    = "terraform.tfstate"
	    region = "us-west-1"
	  }
	}
	$> terraform init
```

## 5. run terraform-apply
```
	ex) http://54.219.182.238:8080/job/terraform-apply/configure
	terraform-apply
	https://github.com/doohee323/tz-terraform-jenkins.git
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
