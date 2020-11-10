output "cloudtrail_s3_bucket" {
  value = aws_s3_bucket.cloudtrail
}

output "web_alb_log_bucket" {
  value = aws_s3_bucket.alb_log
}
