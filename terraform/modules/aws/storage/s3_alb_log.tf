data "template_file" "alb_log_bucket_policy" {
  template = "${file("${path.module}/templates/alb_log_bucket_policy.json")}"

  vars = {
    name                = var.name
    env                 = var.env
    aws_account_id      = var.aws_account_id
    elb_service_account = var.web_alb_service_account
  }
}

resource "aws_s3_bucket" "alb_log" {
  bucket        = "${var.name}-${var.env}-web-alb-log-bucket-${var.aws_account_id}"
  acl           = "private"
  force_destroy = true

  lifecycle_rule {
    id      = "log"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }

    tags = merge(var.common_tags, {
      Name = format("%s-%s-web-alb-log-bucket", var.name, var.env),
      Role = "bucket"
    })
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.bucket
  policy = data.template_file.alb_log_bucket_policy.rendered
}
