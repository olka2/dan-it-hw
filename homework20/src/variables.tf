variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "environment" {
  type = string
}

variable "subnets_cidr" {
  type = any
}

variable "vpc_id" {
  description = "Existing VPC"
  type        = string
}

variable "allowed_ports" {
  type        = list(number)
  description = "List of allowed inbound ports"
}