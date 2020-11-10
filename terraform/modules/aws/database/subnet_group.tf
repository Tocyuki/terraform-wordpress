resource "aws_db_subnet_group" "db" {
  name        = "${var.name}-${var.env}-db-subnet"
  description = "Database Subnet Group for ${var.name}-${var.env}"
  subnet_ids  = var.private_subnets[*].id

  tags = merge(var.common_tags, {
    Name = format("%s-%s-db-subnet", var.name, var.env)
  })
}
