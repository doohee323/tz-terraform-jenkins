# tz-terraform-jenkins

## 1. make and run packer-build in jenkins
```
packer-build
https://github.com/doohee323/packer-build.git
bash jenkins-terraform.sh
```

## 2. get S3 bucket name
```
$> terraform output
app-ip = [
  [],
]
jenkins-ip = [
  [
    "54.151.105.137",
  ],
]
s3-bucket = terraform-state-k2vuvkxc
```

## 3. uncomment backend.tf and rename bucket from terraform output
```
terraform {
  backend "s3" {
    bucket = "terraform-state-k2vuvkxc"
    key    = "terraform.tfstate"
    region = "us-west-1"
  }
}
$> terraform init
```

## 4. make a jenkins project, terraform-apply
```
terraform-apply
https://github.com/doohee323/terraform-course.git
bash jenkins-packer-build/scripts/jenkins-run-terraform.sh
and build terraform-apply project.
```
