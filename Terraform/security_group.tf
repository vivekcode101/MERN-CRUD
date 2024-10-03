module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db"
  description = "Security group for db with port 27017 open for backend"
  vpc_id      = "module.three_tier_vpc.vpc_id"

  # Ingress rules
  ingress_rules = ["http-80-tcp"]

  ingress_with_source_security_group_id = [
    {
      from_port                = 27017
      to_port                  = 27017
      protocol                 = "tcp"
      description              = "Allow MongoDB access from backend"
      source_security_group_id = "module.backend_sg.security_group_id" # Replace with the actual SG ID of your backend
    }
  ]
  # Egress rule to allow traffic to all
  egress_rules = ["all-all"]

  tags = {
    Terraform   = "db_sg"
    Environment = "three_tier"
  }
  depends_on = [module.three_tier_vpc.vpc_id]
}

output "db_sg_id" {
  value = module.db_sg.security_group_id
  description = "The ID of the db security group"
}

module "backend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "backend_asg"
  description = "Security group for backend with port 8080 open for internal alb"
  vpc_id      = "module.three_tier_vpc.vpc_id"

  # Ingress rules
  ingress_rules = ["http-80-tcp"]

  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      description              = "Allow Backend access from internal ALB"
      source_security_group_id = "module.backend_sg.security_group_id" # Replace with the actual SG ID of your internal ALB
    }
  ]
  # Egress rule to allow traffic to all
  egress_rules = ["all-all"]

  tags = {
    Terraform   = "backend_sg"
    Environment = "three_tier"
  }
  depends_on = [module.three_tier_vpc.vpc_id, module.db_sg.security_group_id]
}



module "internal_alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "internal_alb_asg"
  description = "Security group for internal_alb with port 443 open for frontend"
  vpc_id      = "module.three_tier_vpc.vpc_id"

  # Ingress rules
  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow frontend to access backend"
      source_security_group_id = "module.frontend_sg.security_group_id" # Replace with the actual SG ID of your internal ALB
    }
  ]
  # Egress rule to allow traffic to all
  egress_rules = ["all-all"]

  tags = {
    Terraform   = "internal_alb_sg"
    Environment = "three_tier"
  }
  depends_on = [module.three_tier_vpc.vpc_id, module.backend_sg.security_group_id]
}


module "frontend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "frontend_sg"
  description = "Security group for frontend_sg with port 3000 open for internet facing alb"
  vpc_id      = "module.three_tier_vpc.vpc_id"

  # Ingress rules
  ingress_rules = ["http-80-tcp"]

  ingress_with_source_security_group_id = [
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      description              = "Allow frontend to access backend"
      source_security_group_id = "module.internet_facing_alb_sg.security_group_id" # Replace with the actual SG ID of your internal ALB
    }
  ]
  # Egress rule to allow traffic to all
  egress_rules = ["all-all"]

  tags = {
    Terraform   = "frontend_sg"
    Environment = "three_tier"
  }
  depends_on = [module.three_tier_vpc.vpc_id, module.internal_alb_sg.security_group_id]
}


module "internet_facing_alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "internet_facing_alb_sg"
  description = "Security group for internet_facing_alb_sg with port 443 open for internet "
  vpc_id      = "module.three_tier_vpc.vpc_id"

  # Ingress rules
  ingress_rules = ["https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow internet_facing_alb_sg from internet"
      cidr_blocks              = "0.0.0.0/0" # To be accessible from the internet
    }
  ]
  # Egress rule to allow traffic to all
  egress_rules = ["all-all"]

  tags = {
    Terraform   = "internet_facing_alb_sg"
    Environment = "three_tier"
  }
  depends_on = [module.three_tier_vpc.vpc_id, module.frontend_sg.security_group_id]
}

