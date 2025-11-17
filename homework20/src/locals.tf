locals {
  common_tags = {
    "environment"   = var.environment
    "managed_by_tf" = "true"
  }

  resourse_name = "%s-${var.environment}"
}