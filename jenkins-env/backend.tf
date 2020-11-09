terraform {
  backend "s3" {
    bucket = "terraform-state-ob0uxx55"
    key    = "terraform.tfstate"
    region = "us-west-1"
  }
}
