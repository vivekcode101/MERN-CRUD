resource "aws_route53_record" "www" {
  zone_id    = "Z001058038DKUKOHU77Z8"
  name       = "task.thevy.xyz"
  type       = "CNAME"
  ttl        = 300
  records    = [module.internet_alb.dns_name]
  depends_on = [module.internal_alb]
}