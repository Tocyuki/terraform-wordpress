resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.name}-${var.env}-cloudtrail"
  s3_bucket_name                = var.cloudtrail_s3_bucket
  include_global_service_events = false
}
