resource "aws_acm_certificate" "my_domain" {
  domain_name       = "thevy.xyz"
  validation_method = "DNS"
  tags = {
    Terraform       = "SSL for thevy.xyz"
    Environment = "production"
  }
}

data "aws_route53_zone" "my_domain" {
  name         = "thevy.xyz"
  private_zone = false
}

resource "aws_route53_record" "my_domain" {
  for_each = {
    for dvo in aws_acm_certificate.my_domain.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.my_domain.zone_id
}

resource "aws_acm_certificate_validation" "my_domain" {
  certificate_arn         = aws_acm_certificate.my_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.my_domain : record.fqdn]
}
