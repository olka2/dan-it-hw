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

variable "subnets_cidr" {
  type = any
}

variable "resourse_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  description = "Existing VPC"
  type        = string
}

variable "allowed_ports" {
  type        = list(number)
  description = "List of allowed inbound ports"
}