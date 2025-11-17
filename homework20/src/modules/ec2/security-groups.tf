resource "aws_security_group" "sg_public" {
  name        = format(var.resourse_name, "sg_public")
  description = "sg for public"
  vpc_id      = data.aws_vpc.main.id

  tags = merge(var.common_tags, { "Name" = format(var.resourse_name, "sg_public") })

dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description      = "Allow port ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}