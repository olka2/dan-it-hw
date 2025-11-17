module "ec2" {
  source        = "./modules/ec2"
  aws_region    = var.aws_region
  environment   = var.environment
  allowed_ports = var.allowed_ports
  vpc_id        = var.vpc_id
  subnets_cidr = var.subnets_cidr
  common_tags   = local.common_tags
  resourse_name = local.resourse_name
}