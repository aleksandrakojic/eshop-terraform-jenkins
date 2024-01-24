# Declare variables.
variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
}

variable "tfe_tag_name" {
  description = "Tag name for TFE instance"
  type        = string
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI Id for EC2 instance"
}

variable "eu_availability_zone" {
  type        = string
  description = "Availability Zones"
}

variable "key_name" {
  type        = string
  description = "SSH key name for EC2 instance"
}
