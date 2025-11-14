resource "aws_instance" "public" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  key_name               = var.key_name
  tags                   = merge(local.common_tags, { "Name" = format(local.resourse_name, "public") })
}

resource "aws_instance" "private" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.sg_private.id]
  key_name               = var.key_name
  tags                   = merge(local.common_tags, { "Name" = format(local.resourse_name, "private") })
}
