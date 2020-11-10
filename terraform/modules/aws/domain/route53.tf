data "aws_route53_zone" "main" {
  name         = var.naked_domain
  private_zone = false
}
