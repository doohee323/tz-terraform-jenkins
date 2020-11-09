terraform {
  backend "s3" {
    bucket = "terraform-state-on87pwpr"
    key    = "terraform.tfstate"
    region = "us-west-1"
  }
}
