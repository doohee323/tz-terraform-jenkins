# tz-terraform-jenkins

## 1. make a working vm in vagrant
```
	scripts/install.sh
	
	install terraform, packer etc

```

## 2. make jenkins env.
```
	- make aws credentials
	- make a ssh key
	- make a jenkins instance in aws
	- make two jenkins projects

	ex) http://54.219.182.238:8080

```

## 2. run packer-build in jenkins
```
	ex) http://54.219.182.238:8080/job/packer-build/configure
	packer-build
	https://github.com/doohee323/tz-terraform-jenkins.git
	cd ${WORKSPACE}/packer-build
	bash jenkins-terraform.sh
```

## 3. uncomment backend.tf and rename bucket from terraform output
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

## 4. run terraform-apply
```
	ex) http://54.219.182.238:8080/job/terraform-apply/configure
	terraform-apply
	https://github.com/doohee323/tz-terraform-jenkins.git
	cd ${WORKSPACE}/jenkins-env/scripts
	bash jenkins-run-terraform.sh
```


## 5 destroy aws resources
```
	vagrant ssh
	sudo su
	cd /vagrant/jenkins-env
	terraform destroy
	
	
	Need to delete s3 bucket and ami manually.
	

```
