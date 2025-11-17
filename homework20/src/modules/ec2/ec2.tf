resource "aws_instance" "public" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  user_data              = templatefile("${path.module}/templates/user-data.sh", {
    environment = var.environment
  })
  user_data_replace_on_change = true
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  associate_public_ip_address = true
  tags                   = merge(var.common_tags, { "Name" = format(var.resourse_name, "nginx") })
}