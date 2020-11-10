resource "aws_ssm_parameter" "system_name" {
  name        = "${var.name}-system-name"
  description = "System name for ${var.name}"
  type        = "String"
  value       = var.name

  tags = merge(var.common_tags, { Name = format("%s-param-system-name", var.name) })
}

resource "aws_ssm_parameter" "efs_id" {
  name        = "${var.name}-efs-id"
  description = "EFS id for ${var.name}"
  type        = "String"
  value       = aws_efs_file_system.web.id

  tags = merge(var.common_tags, { Name = format("%s-param-efs-id", var.name) })
}
