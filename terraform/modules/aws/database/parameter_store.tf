resource "aws_ssm_parameter" "db_dbname" {
  name        = "${var.name}-db-dbname"
  description = "Database dbname for ${var.name}"
  type        = "String"
  value       = aws_rds_cluster.db.database_name

  tags = merge(var.common_tags, { Name = format("%s-param-db-dbname", var.name) })
}

resource "aws_ssm_parameter" "db_user" {
  name        = "${var.name}-db-username"
  description = "Database user for ${var.name}"
  type        = "String"
  value       = aws_rds_cluster.db.master_username

  tags = merge(var.common_tags, { Name = format("%s-param-db-user", var.name) })
}

resource "aws_ssm_parameter" "db_password" {
  name        = "${var.name}-db-password"
  description = "Database password for ${var.name}"
  type        = "SecureString"
  value       = aws_rds_cluster.db.master_password

  tags = merge(var.common_tags, { Name = format("%s-param-db-password", var.name) })
}

resource "aws_ssm_parameter" "db_cluster_endpoint" {
  name        = "${var.name}-db-cluster-endpoint"
  description = "Database endpoint for ${var.name}"
  type        = "String"
  value       = aws_rds_cluster.db.endpoint

  tags = merge(var.common_tags, { Name = format("%s-param-db-cluster-endpoint", var.name) })
}
