terraform {
  backend "s3" {
    bucket = "terraform-state-k2vuvkxc"
    key    = "terraform.tfstate"
    region = "us-west-1"
  }
}
