module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "thevy.xyz"
  zone_id     = "Z01325983DWPRYQIEDNLY" # Ensure this is the correct Hosted Zone ID for your domain

  validation_method = "DNS"

  subject_alternative_names = [
    "*.thevy.xyz",
    "app.sub.thevy.xyz",
  ]

  wait_for_validation = true

  tags = {
    Terraform   = "ssl_cert"
    Environment = "three_tier"
  }
}
