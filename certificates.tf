# Create Certificate
resource "aws_acm_certificate" "prod_lb_cert" {
  domain_name       = "${var.lb_hostname}.${var.umf_host_name}"
  validation_method = "DNS"

  tags = {
    Name        = "umf-prod-lb-certificate"
  }
}

# Create AWS Route 53 Certificate Validation Record
resource "aws_route53_record" "prod_lb_cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.prod_lb_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

# Create Certificate Validation
resource "aws_acm_certificate_validation" "prod_cert_validation" {
  certificate_arn         = aws_acm_certificate.prod_lb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.prod_lb_cert_validation_record : record.fqdn]
}
