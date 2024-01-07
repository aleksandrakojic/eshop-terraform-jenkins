terraform {
  backend "s3" {
    bucket = "devops-jenkins-remote-state"
    key    = "devops/jenkins/terraform.tfstate"
    region = "eu-west-1"
  }
}