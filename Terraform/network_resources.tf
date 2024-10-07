module "three_tier_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "three_tier_vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]
  private_subnets = [
    "10.0.1.0/24", # First subnet goes to us-east-1a
    "10.0.2.0/24", # Second subnet goes to us-east-1b
    "10.0.3.0/24", # Third subnet goes back to us-east-1a
    "10.0.4.0/24", # Fourth subnet goes to us-east-1b
    "10.0.5.0/24"  # Fifth subnet goes back to us-east-1a
  ]

  public_subnets = [
    "10.0.101.0/24", # First public subnet goes to us-east-1a
    "10.0.102.0/24"  # Second public subnet goes to us-east-1b
  ]


  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "vpc"
    Environment = "three_tier"
  }
}
