resource "aws_instance" "public" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  user_data = templatefile("${path.module}/templates/user-data.sh", {
    public_key = trimspace(file(var.public_key_path))
  })
  user_data_replace_on_change = true
  tags                        = merge(local.common_tags, { "Name" = format(local.resourse_name, "public") })
}

resource "aws_spot_instance_request" "private" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_b.id
  user_data = templatefile("${path.module}/templates/user-data.sh", {
    public_key = trimspace(file(var.public_key_path))
  })
  user_data_replace_on_change = true
  spot_type                   = "one-time"
  wait_for_fulfillment        = true
  vpc_security_group_ids      = [aws_security_group.sg_private.id]
  tags                        = merge(local.common_tags, { "Name" = format(local.resourse_name, "private") })
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible-playbook-webserver/inventory"

  content = templatefile("${path.module}/ansible_inventory.tpl", {
    public_ip  = aws_instance.public.public_ip
    private_ip = aws_spot_instance_request.private.private_ip
  })

  depends_on = [
    aws_instance.public
  ]
}
