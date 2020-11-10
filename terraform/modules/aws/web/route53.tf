resource "aws_route53_record" "web" {
  zone_id = var.route53_zone.id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_alb.web.dns_name
    zone_id                = aws_alb.web.zone_id
    evaluate_target_health = true
  }
}
