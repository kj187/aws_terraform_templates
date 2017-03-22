variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "eu-west-1"
}

variable "availability_zones" {
  description = "The availability zone"
  default = "eu-west-1a"
}

variable "vpc_subnet_availability_zone" {
  description = "The VPC subnet availability zone"
  default = "eu-west-1a"
}
