data "aws_route53_zone" "hosted_zone" {
  name         = var.umf_host_name
  private_zone = false
}

# Create AWS Route53 A Record for the Load Balancer
resource "aws_route53_record" "umf_prod_alb_record" {
  depends_on = [aws_lb.umf_prod_lb]
  zone_id    = data.aws_route53_zone.hosted_zone.zone_id
  name       = "${var.lb_hostname}.${var.umf_host_name}"
  type       = "A"

  alias {
    name                   = aws_lb.umf_prod_lb.dns_name
    zone_id                = aws_lb.umf_prod_lb.zone_id
    evaluate_target_health = true
  }
}
