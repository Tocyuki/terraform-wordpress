resource "aws_security_group" "db" {
  name        = "${var.name}-${terraform.workspace}-db"
  description = "Controls access to the ${var.name}-${terraform.workspace} DB"
  vpc_id      = var.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-db-sg", var.name, terraform.workspace)
  })
}
