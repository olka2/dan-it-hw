terraform {
  required_version = "~>1.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "dan-test-terraform-state12345"
    region = "eu-central-1"
    key          = "terraform/terraform.tfstate"
    use_lockfile = true
  }
}
provider "aws" {
  region = var.aws_region
}