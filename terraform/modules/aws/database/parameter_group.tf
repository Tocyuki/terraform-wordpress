resource "aws_rds_cluster_parameter_group" "db" {
  name        = "${var.name}-${terraform.workspace}-cluster-pg"
  family      = local.family
  description = "Database cluster parameter group for ${var.name}-${terraform.workspace}"

  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_general_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-db-cluster-pg", var.name, terraform.workspace),
    Role = "parameter-group"
  })
}

resource "aws_db_parameter_group" "db" {
  name        = "${var.name}-${terraform.workspace}-db-pg"
  description = "Database parameter group for ${var.name}-${terraform.workspace}"
  family      = local.family

  tags = merge(var.common_tags, {
    Name = format("%s-%s-db-pg", var.name, terraform.workspace),
    Role = "parameter-group"
  })
}
