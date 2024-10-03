module "three_tier_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "three_tier_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "vpc"
    Environment = "three_tier"
  }
}
output "vpc_id" {
  value = module.three_tier_vpc.vpc_id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value = module.three_tier_vpc.public_subnets
  description = "The ID of the public subnets"  
}

output "private_subnets_ids" {
  value = module.three_tier_vpc.private_subnets
  description = "The ID of the private subnets"
}
