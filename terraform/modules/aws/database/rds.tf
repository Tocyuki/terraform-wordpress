resource "random_id" "passowrd" {
  byte_length = 16
}

resource "aws_rds_cluster" "db" {
  cluster_identifier = "${var.name}-${terraform.workspace}-db-cluster"

  # engine
  engine         = local.engine
  engine_version = local.engine_version
  engine_mode    = var.engine_mode

  # param
  database_name                   = var.name
  master_username                 = var.username
  master_password                 = random_id.password.b64
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db.name

  # network
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.db.name

  # backup
  backup_retention_period = 7
  preferred_backup_window = "19:30-20:00"

  # maintenance
  preferred_maintenance_window = "wed:20:15-wed:20:45"
  skip_final_snapshot          = true

  tags = merge(var.common_tags, {
    Name = format("%s-%s-db-cluster", var.name, terraform.workspace),
    Role = "db"
  })
}

resource "aws_rds_cluster_instance" "db" {
  count = 1

  identifier         = "${var.name}-${terraform.workspace}-db-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.db.id

  # engine
  engine         = local.engine
  engine_version = local.engine_version

  # param
  instance_class          = var.instance_class
  db_subnet_group_name    = aws_db_subnet_group.db.name
  db_parameter_group_name = aws_db_parameter_group.db.name

  tags = merge(var.common_tags, {
    Name = format("%s-%s-db-%s", var.name, terraform.workspace, count.index + 1),
    Role = "db"
  })
}
