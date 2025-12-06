resource "aws_instance" "web" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  key_name               = var.key_name
  tags                   = merge(local.common_tags, { "Name" = format(local.resourse_name, "web") })
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible-playbook-webserver/inventory"

  content = templatefile("${path.module}/ansible_inventory.tpl", {
    web_ips = aws_instance.web[*].public_ip
  })

  depends_on = [
    aws_instance.web
  ]
}