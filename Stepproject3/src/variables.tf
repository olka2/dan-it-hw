variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "vpc_cidr_block" {
  type = string
}

variable "subnets_cidr" {
  type = any
}

variable "public_key_path" {
  type = string
}