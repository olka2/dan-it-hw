resource "aws_security_group" "sg_public" {
  name        = format(local.resourse_name, "sg_public")
  description = "sg for public"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, { "Name" = format(local.resourse_name, "sg_public") })

}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = var.subnets_cidr.my_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "sg_private" {
  name        = format(local.resourse_name, "sg_private")
  description = "sg for private"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, { "Name" = format(local.resourse_name, "sg_private") })

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_public" {
  security_group_id            = aws_security_group.sg_private.id
  referenced_security_group_id = aws_security_group.sg_public.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.sg_private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
