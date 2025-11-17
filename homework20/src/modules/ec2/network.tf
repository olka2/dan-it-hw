resource "aws_subnet" "public_a" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = var.subnets_cidr.public_a
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { "Name" = format(var.resourse_name, "public_a") })

}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = data.aws_vpc.main.id

  tags = merge(var.common_tags, { "Name" = format(var.resourse_name, "main_gw") })

}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = merge(var.common_tags, { "Name" = format(var.resourse_name, "public_rt") })

}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}