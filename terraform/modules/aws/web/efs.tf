resource "aws_efs_file_system" "web" {
  creation_token = "${var.name}-${var.env}-web-efs"

  tags = merge(var.common_tags, {
    Name = format("%s-%s-web-efs", var.name, var.env),
    Role = "filesystem"
  })
}

resource "aws_efs_mount_target" "web" {
  count = length(var.azs)

  file_system_id  = aws_efs_file_system.web.id
  subnet_id       = element(var.public_subnets[*].id, count.index)
  security_groups = [aws_security_group.efs.id]
}
