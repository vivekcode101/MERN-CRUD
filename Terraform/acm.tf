module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name       = "thevy.xyz"
  zone_id           = "Z001058038DKUKOHU77Z8"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.thevy.xyz",
  ]

  wait_for_validation = true

  tags = {
    Terraform   = "ssl_cert"
    Environment = "three_tier"
  }
}