terraform {
  backend "s3" {
    bucket = "devops-tools-remote-state"
    key    = "monitoring/terraform.tfstate"
    region = "eu-west-1"
  }
}
