data "template_file" "cloudtrail_bucket_policy" {
  template = "${file("${path.module}/templates/cloudtrail_bucket_policy.json")}"

  vars = {
    name           = var.name
    env            = var.env
    aws_account_id = var.aws_account_id
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.name}-${var.env}-cloudtrail-${var.aws_account_id}"
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

    tags = merge(var.common_tags, {
      Name = format("%s-%s-cloudtrail", var.name, var.env),
      Role = "bucket"
    })
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.template_file.cloudtrail_bucket_policy.rendered
}
