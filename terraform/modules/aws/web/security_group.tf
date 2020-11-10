resource "aws_security_group" "web" {
  name        = "${var.name}-${var.env}-web-sg"
  description = "Controls access to the web"
  vpc_id      = var.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-web-sg", var.name, var.env)
  })
}

resource "aws_security_group_rule" "web" {
  type                     = "ingress"
  to_port                  = 80
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.web.id
}

resource "aws_security_group_rule" "db" {
  type                     = "ingress"
  to_port                  = 3306
  from_port                = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web.id
  security_group_id        = var.db_security_group.id

  depends_on = [var.db_security_group]
}

resource "aws_security_group_rule" "efs" {
  type                     = "ingress"
  to_port                  = 2049
  from_port                = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web.id
  security_group_id        = aws_security_group.efs.id
}

resource "aws_security_group" "alb" {
  name        = "${var.name}-${var.env}-web-alb-sg"
  description = "Controls access to the ALB"
  vpc_id      = var.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-web-alb-sg", var.name, var.env)
  })
}

resource "aws_security_group" "efs" {
  name        = "${var.name}-${var.env}-web-efs-sg"
  description = "Controls access to the EFS"
  vpc_id      = var.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-web-efs-sg", var.name, var.env)
  })
}
