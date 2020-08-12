resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.common_tags, {
    Name = format("%s-%s-igw", var.name, terraform.workspace),
    Role = "internet-gateway"
  })
}

resource "aws_eip" "nat_gateway" {
  count      = length(var.azs)
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]

  tags = merge(var.common_tags, {
    Name = format("%s-%s-ngw-%s-eip", var.name, terraform.workspace, element(split("-", element(var.azs, count.index)), 2)),
    Role = "elastic-ip"
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.azs)
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  allocation_id = element(aws_eip.nat_gateway[*].id, count.index)

  tags = merge(var.common_tags, {
    Name = format("%s-%s-ngw-%s", var.name, terraform.workspace, element(split("-", element(var.azs, count.index)), 2)),
    Role = "nat-gateway"
  })
}
